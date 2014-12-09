# Unmount the "pass through" bindings that prep.sh did

#check for pesky symbolic link
if [ -h ${SD_BASE} ]
then
    SD_BASE=`readlink ${SD_BASE}`
    echo "SD_BASE is linked to ${SD_BASE}"
fi


for i in target sys proc dev data
do
    if ${BB} mount | ${BB} grep -q ${IMG}/$i
    then
        ${BB} umount -l ${SD_BASE}/${IMG}/$i
        if ${BB} mount | ${BB} grep -q ${IMG}/$i
        then
            for bad_mt in  `${BB} mount | ${BB} grep ${IMG}/$i | ${BB} cut -d \  -f 3`
            do
                echo "warning: failed to verify umount ${bad_mt}"
            done
            echo "...lazy umount attempted..."
            echo "wait a bit and try unprep to verify umounts"
        else
            echo "umount ${i} succeessful"
        fi
        
    else
        echo "$0: $i is not mounted"
    fi
done


# Now unmount the sdk
if ${BB} mount | ${BB} grep -q ${IMG}
then
    ${BB} umount -f ${SD_BASE}/${IMG}
fi
    
    
# Check
if ${BB} mount | ${BB} grep -q ${SD_BASE}/${IMG}
then
    echo "$0: sdk failed to unmount"
fi

 



