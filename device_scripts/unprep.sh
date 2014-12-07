#this is a monolithic unprep script

#set variables
source prep_config.sh
#perform custom steps
if [ ${CUSTOM_UNPREP} = "False" ]
then
    echo "no custom setup"
else
    source ${CUSTOM_UNPREP}
fi

#perform device-nonspecific steps
source generic_unprep.sh

echo "$0: Ubuntu chroot prep has been un-done."
