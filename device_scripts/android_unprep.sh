# Skip unmount activities if not needed
if ${BB} mount | ${BB} grep -q ${SD_BASE}
then
    # Unmount the "pass through" bindings that prep.sh did
    for i in data
    do
        if ${BB} mount | ${BB} grep -q ${SD_BASE}/${IMG}/$i
        then
            ${BB} umount ${SD_BASE}/${IMG}/$i
        else
            echo "$0: $i is not mounted"
        fi
    done
else
    echo "$0: SD card appears to be unmounted"
fi
