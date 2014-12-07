# - rmmod the IQ driver KM
# - kill ipcserver and modemd
# - delete modemd_pipe and status_fifo


# source (or initialize) the configuration
source prep_config.sh

if lsmod | ${BB} grep -q "^hs_data .* Live "
then
    rmmod hs_data.ko
fi

if ps | ${BB} grep -q "ipcserver"
then
    ipc_pid=`ps | ${BB} grep [i]pcserver | ${BB} awk '{print $2}'`
    kill $ipc_pid
fi

if ps | ${BB} grep -q "modemd"
then
    md_pid=`ps | ${BB} grep [m]odemd | ${BB} awk '{print $2}'`
    kill $md_pid
fi

if [ -e /data/modemd_pipe ]
then
    rm /data/modemd_pipe
fi

if [ -e /data/status_fifo ]
then
    rm /data/status_fifo 
fi


