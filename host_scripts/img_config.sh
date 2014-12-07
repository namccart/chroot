#! /usr/bin/env bash

if [ -e img_config.dat ]
then 
    source img_config.dat
fi

if [ -z ${IMG_SIZE} ]
then
    echo "enter img size in GB [4]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=4
    fi
    echo "IMG_SIZE=${inp}" >> img_config.dat
else
    echo "IMG_SIZE is ${IMG_SIZE}GB"
fi

if [ -z ${ROOTFS} ]
then
    echo "enter the location of the sdk [/home/namccart/oecore-x86_64/sysroots/cortexa9hf-vfp-neon-oe-linux-gnueabi]:"
    read inp
    if [ -z ${inp} ]
    then
        inp=/home/namccart/oecore-x86_64/sysroots/cortexa9hf-vfp-neon-oe-linux-gnueabi
    fi
    echo "ROOTFS=${inp}" >> img_config.dat
else
    echo "ROOTFS is ${ROOTFS}"
fi

#now resource to catch updates
source img_config.dat
