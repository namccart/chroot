#! /usr/bin/env bash

source img_config.sh

echo "Creating, populating, and archiving the new image.  This will take a few minutes..."

sleep 3

SEEK_SIZE=$(($IMG_SIZE*1024))
echo "making img file..."
dd if=/dev/zero of=sdk.img bs=1MB count=0 seek=${SEEK_SIZE}
mkfs.ext4 -F sdk.img

RM_MOUNT_POINT=""
if [ -e /mnt/sdk ]
then
    echo "mount point /mnt/sdk exists"
else
    echo "creating mount point..."
    sudo mkdir /mnt/sdk
    RM_MOUNT_POINT="True"
fi

UNMOUNT_IMG=""
if mount | grep -q /mnt/sdk
then
    echo "sdk mounted"
else
    echo "mounting img file..."
    sudo mount -o loop sdk.img /mnt/sdk
    UNMOUNT_IMG="True"
fi

echo "populating the img from ROOTFS..."
sudo cp -r ${ROOTFS}/usr /mnt/sdk
sudo cp -r ${ROOTFS}/bin /mnt/sdk
sudo cp -r ${ROOTFS}/lib /mnt/sdk
sudo mkdir /mnt/sdk/target
sudo mkdir /mnt/sdk/proc
sudo mkdir /mnt/sdk/dev
sudo mkdir /mnt/sdk/data
sudo mkdir /mnt/sdk/sys

echo "unmounting the image..."

if [ -z ${UNMOUNT_IMG} ]
then
    echo "leaving sdk mounted"
else
    sudo umount /mnt/sdk
fi

if [ -z ${RM_MOUNT_POINT} ]
then
    echo "leaving /mnt/sdk mountpoint in place"
else
    echo "removing mount point..."
    sudo rmdir /mnt/sdk
fi

echo "archiving the image..."
tar -czvf sdk.img.tar.gz sdk.img

rm sdk.img

echo `ls -lh sdk.img.tar.gz`
