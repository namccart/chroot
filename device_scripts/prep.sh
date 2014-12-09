#this is a monolithic prep script for chroot setup

EXIT_STATUS=0

#set variables
source prep_config.sh

#parse arguments
if [ ${#} = 1 ]
then
    if [ ${1} = '--sandbox_reload' ] || [ ${1} = '-s' ]
    then
        if ! [ -e ${SD_BASE}/target.tar.gz ]
        then
            echo "You must push \"target.tar.gz\" to the mount point for sdk in order to use the sandbox_reload option."
            EXIT_STATUS=1
        else 
            if [ -e ${PREFIX} ]
            then
                ${BB} rm -rf ${PREFIX}
            fi
            if [ -e ${SD_BASE}/target.tar ]
            then
                ${BB} rm ${SD_BASE}/target.tar
            fi
        
            ${BB} gunzip ${SD_BASE}/target.tar.gz
            ${BB} tar -xvf ${SD_BASE}/target.tar -C ${SD_BASE}
            if ! [ -e ${PREFIX} ]
            then
                echo "failed to reload the sandbox"
                EXIT_STATUS=1
            fi
        fi
    elif [ ${1} = '--help' ] ||  [ ${1} = '-h' ]
    then
        echo "SYNOPSIS"
        echo "    prep.sh [options]"
        echo "OPTIONS"
        echo "    -s, --sandbox_reload"
        echo "        Perform a reinstallation of the sandbox as part of the chroot preparation.  Assumes target.tar.gz exists in the mount point for sdk."
        echo "    -h, --help"
        echo "        Print this help message."
        EXIT_STATUS=1
    fi
fi

#perform device-nonspecific steps
if [ ${EXIT_STATUS} = 0 ]
then
    source generic_prep.sh
fi
#perform custom steps
if [ ${CUSTOM_PREP} = "False" ] && [ ${EXIT_STATUS} = 0 ]
then
    echo "no custom setup"
elif [ ${EXIT_STATUS} = 0 ]
then
    source ${CUSTOM_PREP}
fi
#chroot!
if [ ${EXIT_STATUS} = 0 ]
then
    source go.sh
fi



