#android-specific setup


#/data is a good place in android to mess access system (not sdcard) memory
for i in data
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
