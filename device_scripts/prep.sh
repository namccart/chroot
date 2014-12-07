#this is a monolithic prep script for grmp

#set variables
source prep_config.sh
#perform device-nonspecific steps
source generic_prep.sh
#perform custom steps
if [ ${CUSTOM_PREP} = "False" ]
then
    echo "no custom setup"
else
    source ${CUSTOM_PREP}
fi
#chroot!
source go.sh


