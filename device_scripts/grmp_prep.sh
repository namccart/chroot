#grmp-specific setup

#set grmp-specific variables
source grmp_config.sh

# Disable watchdog
echo 1 > /sys/module/msm_watchdog/parameters/runtime_disable


if [ -e ${DEVICE_DATA_ROOT}/modemd_pipe ]
then
  echo "$0: modemd_pipe fifo already exists"
else
  ${BB} mkfifo ${DEVICE_DATA_ROOT}/modemd_pipe
fi

if [ -e /data/status_fifo ]
then
  echo "$0: status_fifo fifo already exists"
else
  ${BB} mkfifo ${DEVICE_DATA_ROOT}/status_fifo
fi

if ps | ${BB} grep ipcserver
then
  echo "$0: ipcserver already running"
else
    ${DEVICE_DATA_ROOT}/ipcserver
fi

if ps | ${BB} grep modemd
then
  echo "$0: modemd already running"
else
    ${DEVICE_DATA_ROOT}/modemd -p ${DEVICE_DATA_ROOT}/modemd_pipe -o ${DEVICE_DATA_ROOT}/status_fifo -d 
fi


echo cmd=enter > /data/modemd_pipe

# modemd takes a little time to service the pipe
sleep 3

# Load the HS_DATA driver if needed
if lsmod | ${BB} grep -q "^hs_data .* Live "
then
  echo "$0: HS_DATA driver is already loaded"
else
  # Load the HS_DATA Driver
  insmod ${HS_DATA_KO}
  if ! lsmod | ${BB} grep -q "^hs_data .* Live "
  then
    echo "$0: HS_DATA driver failed to Load"
    EXIT_STATUS=1
  fi
fi


