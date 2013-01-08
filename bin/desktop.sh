#!/bin/bash

SPATH=`dirname "$(readlink -f "$0")"`

echo "Desktop environment install launched."
echo -n "Continue ? (y/N) "
read CHOICE

if [[ $CHOICE == "y" ]]; then

    echo -n "And who is the main user ? "
    read MAINUSER

    if ! [ -z $MAINUSER ]; then

        apt-get update
        apt-get install -y xorg openbox obconf obmenu tint2 xcompmgr feh rxvt-unicode
        apt-get install -y lxappearance tango-icon-theme conky grun gksu suckless-tools ttf-bitstream-vera furiusisomount
        apt-get install -y libnotify-bin notification-daemon
        apt-get install -y alsa alsa-tools alsa-oss alsamixergui
        apt-get install -y cmus vlc scrot pidgin xpdf mirage
        apt-get install -y chromium-browser
        apt-get install -y icedove
        apt-get install -y flashplugin-nonfree
        apt-get install -y virtualbox-ose virtualbox-ose-dkms

        Xorg -configure
        alsactl init

        for file in config conkyrc xinitrc Xdefaults Xresources fonts.conf; do
            cp -R $SPATH/../src/dot/$file /home/$MAINUSER/.$file;
        done
        cp -R $SPATH/../src/images /home/$MAINUSER/
        chown -R $MAINUSER:$MAINUSER /home/$MAINUSER/.*
        chown -R $MAINUSER:$MAINUSER /home/$MAINUSER/*
        xrdb -merge /home/$MAINUSER/.Xresources
    else
        echo "Failed! No user has been given. Retry !";
    fi

fi
