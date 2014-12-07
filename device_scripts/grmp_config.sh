if [ -e grmp_config.dat ]
then 
    source grmp_config.dat
fi

if [ -z ${DEVICE_DATA_ROOT} ]
then
    echo "enter path to utilities root [/data]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=/data
    fi
    echo "DEVICE_DATA_ROOT=${inp}" >> grmp_config.dat
else
    echo "DEVICE_DATA_ROOT is ${DEVICE_DATA_ROOT}"
fi

if [ -z ${HS_DATA_KO} ]
then
    echo "enter kernel module path [\${DEVICE_DATA_ROOT}/hs_data.ko]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=\${DEVICE_DATA_ROOT}/hs_data.ko
    fi
    echo "HS_DATA_KO=${inp}" >> grmp_config.dat
else
    echo "HS_DATA_KO is ${HS_DATA_KO}"
fi

#now resource to catch updates
source grmp_config.dat
