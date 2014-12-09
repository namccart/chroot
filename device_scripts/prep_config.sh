if [ -e config.dat ]
then 
    source config.dat
fi

if [ -z ${SD_DEV} ]
then
    echo "enter device name for sd card"
    echo "(use \"NONE\" to ignore sd card) [mmcblk1p1]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=mmcblk1p1
    fi
    echo "SD_DEV=${inp}" >> config.dat
else
    echo "SD_DEV is ${SD_DEV}"
fi



if [ -z ${SD_BASE} ]
then
    echo "enter mount point for sdk [/sdcard/gnuradio]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=/sdcard/gnuradio
    fi
    echo "SD_BASE=${inp}" >> config.dat
else
    echo "SD_BASE is ${SD_BASE}"
fi

if [ -z ${IMG} ]
then
    echo "enter image file basename [sdk]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=sdk
    fi
    echo "IMG=${inp}" >> config.dat
else
    echo "IMG is ${IMG}"
fi

if [ -z ${PREFIX} ]
then
    echo "enter prefix location [/sdcard/gnuradio/sdk_target]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=/sdcard/gnuradio/sdk_target
    fi
    echo "PREFIX=${inp}" >> config.dat
else
    echo "PREFIX is ${PREFIX}"
fi

if [ -z ${SYS} ]
then
    echo "enter host sys name [system]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=system
    fi
    echo "SYS=${inp}" >> config.dat
else
    echo "SYS is ${SYS}"
fi

if [ -z ${BB} ]
then
    echo "enter the busybox path [/data/sdk/busybox]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=/data/sdk/busybox
    fi
    echo "BB=${inp}" >> config.dat
else
    echo "BB is ${BB}"
fi

if [ -z ${NEW_SHELL} ]
then
    echo "enter the chrooted shell [/bin/bash]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=/bin/bash
    fi
    echo "NEW_SHELL=${inp}" >> config.dat
else
    echo "NEW_SHELL is ${NEW_SHELL}"
fi

if [ -z ${NEW_DATA} ]
then
    echo "enter path to mount under chrooted /data"
    echo "(will attempt to create if path doesn't exist) [/data]:" 
    read inp
    if [ -z ${inp} ]
    then
        inp=/data
    fi
    echo "NEW_DATA=${inp}" >> config.dat
else
    echo "NEW_DATA is ${NEW_DATA}"
fi

if [ -z ${NEW_HOME} ]
then
    echo "enter HOME for chrooted shell [/data/sdk]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=/data/sdk
    fi
    echo "NEW_HOME=${inp}" >> config.dat
else
    echo "NEW_HOME is ${NEW_HOME}"
fi

if [ -z ${CUSTOM_PREP} ]
then
    echo "enter custom setup script"
    echo "(use \"False\" for no customization) [False]:"
    read inp
    if [ -z ${inp} ]
    then
        inp="False"
    fi
    if [ $inp = "False" ]
    then
        echo "CUSTOM_PREP=False" >> config.dat
        echo "CUSTOM_UNPREP=False" >> config.dat
    else
        echo "CUSTOM_PREP=${inp}_prep.sh" >> config.dat
        echo "CUSTOM_UNPREP=${inp}_unprep.sh" >> config.dat
    fi
else
    echo "CUSTOM_PREP is ${CUSTOM_PREP}"
fi



#now resource to catch updates
source config.dat
