# Script to chroot into Ubuntu


# Make a new ~ for Ubuntu instead of /data
export HOME=${NEW_HOME}

if [ -e ${NEW_HOME}/.bash_profile ]
then
    echo "using existing .bash_profile... find it in chroot's HOME"
else
    echo "# sdk_generated .bash_profile" > ${NEW_HOME}/.bash_profile
    echo "# (from the go.sh portion of your prep command)" >> ${NEW_HOME}/.bash_profile
    echo "export PS1='(${SD_BASE}/${IMG}): chroot@${HOST}:\w$ '" >> ${NEW_HOME}/.bash_profile
    echo "export PATH=/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/sbin:/usr/sbin:/sys/bin:/sys/xbin" >> ${NEW_HOME}/.bash_profile
    echo "export TERM=dumb" >> ${NEW_HOME}/.bash_profile
    echo "export SHELL=/bin/bash" >> ${NEW_HOME}/.bash_profile
    
    echo "${NEW_HOME}/.bash_profile generated"
fi

# Allow 'groups' to be found during chroot
export PATH=/usr/bin:$PATH

# Wipe any system LD_PRELOAD
export LD_PRELOAD=

# change root into Ubuntu
# Make shell act as a login to run a login script
${BB} chroot ${SD_BASE}/${IMG} ${NEW_SHELL} --login

# Place these in $HOME/.bash_profile, which runs at the end of chroot.
# (note that ~ resolves to $HOME after chroot)
# export PS1='Ubuntu: $USER@$HOSTNAME:${PWD:-?}# '
# export PATH=/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:/sbin:/usr/sbin:/system/bin:/system/xbin
# export TERM=dumb
# export SHELL=/bin/bash
# export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
# export PYTHONPATH=/src/gnuradio/grc/:$PYTHONPATH
