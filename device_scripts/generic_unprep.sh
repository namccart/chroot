# Unmount the "pass through" bindings that prep.sh did

#check for pesky symbolic link
if [ -h ${SD_BASE} ]
then
    SD_BASE=`readlink ${SD_BASE}`
    echo "SD_BASE is linked to ${SD_BASE}"
fi


for i in target sys proc dev data
do
    if ${BB} mount | ${BB} grep -q ${SD_BASE}/${IMG}/$i
    then
        ${BB} umount ${SD_BASE}/${IMG}/$i
    else
        echo "$0: $i is not mounted"
    fi
done


# Now unmount the sdk
if ${BB} mount | ${BB} grep -q ${SD_BASE}/${IMG}
then
    ${BB} umount ${SD_BASE}/${IMG}
fi
    
    
# Check
if ${BB} mount | ${BB} grep -q ${SD_BASE}/${IMG}
then
    echo "$0: sdk failed to unmount"
fi

 



