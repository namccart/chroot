# Once per boot prep for Ubuntu chroot

#check for pesky symbolic link
if [ -h ${SD_BASE} ]
then
    SD_BASE=`readlink ${SD_BASE}`
fi


# Skip SD card activities if it is mounted
EXIT_STATUS=0
if [ ${SD_DEV} = "NONE" ]
then
    echo "ignoring the sd card"
else
    if ${BB} mount | ${BB} grep -q ${SD_BASE}
    then
        echo "$0: SD card is already mounted"
    else

        # File system check of the SD card
        e2fsck -p /dev/block/${SD_DEV}
        if [ $? -gt 1 ]
        then
            echo "$0: Run $0 again if e2fsck recovery was acceptable."
            EXIT_STATUS=1
        fi

        # Mount the SD card containing the Ubuntu rootfs (auto detect ext* type)
        if ! (${BB} mount -t auto /dev/block/${SD_DEV} ${SD_BASE})
        then
            echo "$0: Failed to mount SD_BASE"
            EXIT_STATUS=1
        fi
    fi
fi

# Make these directories in the Ubuntu rootfs
# map to the real ones in the Android rootfs.
# 'data' is a storage space outside the SD card.
# 'system' allows access to additional commands,
#          like /system/xbin/strace .
# If any of these fail, check there is an empty
# directory of the same name under SD_BASE.
if [ "$EXIT_STATUS" == "0" ]
then
    if ! ${BB} mount | grep -q ${SD_BASE}/${IMG}
    then
        if ! [ -e ${SD_BASE}/${IMG} ]
        then
            mkdir ${SD_BASE}/${IMG}
        fi
        ${BB} mount -o loop ${SD_BASE}/${IMG}.img ${SD_BASE}/${IMG}
    else
        echo "image already mounted"
    fi
    
    for i in dev proc 
    do
        if ${BB} mount | ${BB} grep -q ${SD_BASE}/${IMG}/$i
        then
            echo "$0: $i is already mounted"
        else
            if ! (${BB} mount --bind /$i ${SD_BASE}/${IMG}/$i)
            then
                echo "$0: Failed to mount $i"
                EXIT_STATUS=1
            fi
        fi
    done
    if ${BB} mount | ${BB} grep -q ${SD_BASE}/${IMG}/sys
    then
        echo "$0: sys is already mounted"
    else
        if ! (${BB} mount --bind /${SYS} ${SD_BASE}/${IMG}/sys)
        then
            echo "$0: Failed to mount sys"
            EXIT_STATUS=1
        fi
    fi
    
    if ${BB} mount | ${BB} grep -q ${SD_BASE}/${IMG}/target
    then
        echo "$0: target is already mounted"
    else
        if ! (${BB} mount --bind ${PREFIX} ${SD_BASE}/${IMG}/target)
        then
            echo "$0: Failed to mount target"
            EXIT_STATUS=1
        fi
    fi
    
    if ! [ -e ${NEW_DATA} ]
    then
        #try to make a data dir at ${SD_BASE}
        mkdir ${SD_BASE}/data
        chmod 777 ${SD_BASE}/data
        mkdir ${SD_BASE}/data/gnuradio
        chmod 777 ${SD_BASE}/data/gnuradio
        if [ -e ${SD_BASE}/data ]
        then
            echo "${SD_BASE}/data created"
        else
            echo "/data creation failed"
        fi
        if [ -e ${SD_BASE}/data/gnuradio ]
        
        then
            echo "${SD_BASE}/data/gnuradio created"
        else
            echo "/data/gnuradio creation failed"
        fi
    fi
    if ! (${BB} mount --bind ${NEW_DATA} ${SD_BASE}/${IMG}/data)
    then
        echo "$0: Failed to mount data"
        EXIT_STATUS=1
    fi
        
fi


