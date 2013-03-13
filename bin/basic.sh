#!/bin/bash

SPATH=`dirname "$(readlink -f "$0")"`

echo "Basic system install launched."
echo -n "Continue ? (y/N) "
read CHOICE

if [[ $CHOICE == "y" ]]; then

    echo
    echo -n "Install bash and emacs basic config ? (y/N) "
    read SUBCHOICE

    echo
    echo -n "And who is the main user ? "
    read MAINUSER

    rm -rf /usr/share/man/??
    rm -rf /usr/share/man/??_*
    rm -rf /usr/share/doc/*/copyright*

    cp /etc/apt/sources.list /etc/apt/sources.list.ori
    sed -e 's/ main$/ main contrib non-free/g' -i /etc/apt/sources.list
    apt-get update
    apt-get autoremove --purge -y exim4-.\* portmap rpcbind
    apt-get install -y git subversion curl irb rsync emacs emacs-goodies-el php-elisp tree unzip gcc build-essential linux-headers-$(uname -r) python ruby libruby ruby-dev rubygems libmysql-ruby libactiverecord-ruby libxslt-dev libxml2-dev htop sloccount aria2
    apt-get install -y nmap fail2ban denyhosts tcpdump httperf siege iptraf clamav selinux-basics selinux-policy-default
    selinux-activate

    if [[ $SUBCHOICE == "y" ]]; then

        cp -R $SPATH/../src/bin ~/bin;
        cp -R $SPATH/../src/bin /home/$MAINUSER/bin;
        if ! [ -z $MAINUSER ]; then
            for file in emacs emacs.d bashrc; do
                cp -R $SPATH/../src/dot/$file ~/.$file;
                cp -R $SPATH/../src/dot/$file /home/$MAINUSER/.$file;
            done
            chown -R $MAINUSER:$MAINUSER /home/$MAINUSER/.*
            chown -R $MAINUSER:$MAINUSER /home/$MAINUSER/bin
        else
            echo "Failed! No user has been given. Retry !";
        fi
    fi

fi
