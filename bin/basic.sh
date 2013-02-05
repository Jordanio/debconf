#!/bin/bash

SPATH=`dirname "$(readlink -f "$0")"`

echo "Basic system install launched."
echo -n "Continue ? (y/N) "
read CHOICE

if [[ $CHOICE == "y" ]]; then

    cp /etc/apt/sources.list /etc/apt/sources.list.ori
    sed -e 's/ main$/ main contrib non-free/g' -i /etc/apt/sources.list
    apt-get update
    apt-get autoremove --purge -y exim4-.\* portmap rpcbind
    apt-get install -y git subversion curl irb rsync emacs emacs-goodies-el php-elisp nmap fail2ban denyhosts httperf siege tree unzip gcc build-essential linux-headers-$(uname -r) python task ruby libruby ruby-dev rubygems libmysql-ruby libactiverecord-ruby libxslt-dev libxml2-dev htop sloccount
    apt-get install -y selinux-basics selinux-policy-default
    selinux-activate

    echo
    echo -n "Install bash and emacs basic config ? (y/N) "
    read SUBCHOICE

    if [[ $SUBCHOICE == "y" ]]; then

        echo -n "And who is the main user ? "
        read MAINUSER

        cp $SPATH/../src/fwall.sh ~/fwall.sh;
        if ! [ -z $MAINUSER ]; then
            for file in emacs emacs.d bashrc; do
                cp -R $SPATH/../src/dot/$file ~/.$file;
                cp -R $SPATH/../src/dot/$file /home/$MAINUSER/.$file;
            done
            chown -R $MAINUSER:$MAINUSER /home/$MAINUSER/.*
            source ~/.bashrc
        else
            echo "Failed! No user has been given. Retry !";
        fi
    fi

fi
