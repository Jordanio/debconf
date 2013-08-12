#!/bin/bash

SPATH=`dirname "$(readlink -f "$0")"`

FILESPATH=$SPATH/files

function main_menu {
    printf "\n * 1. Install basic system\n"
    printf " * 2. Install desktop (Openbox)\n"
    printf " * 3. Install web server (Apache2)\n"
    printf " * 4. Install database server (Postgresql/Mysql)\n"
    printf " * 5. Install Pentesting tools\n"
    printf " * 6. Install VirtualBox\n"
    printf " * 7. Deploy configs\n"
    printf " * 0. Exit\n\n"
}

function do_exit {
    printf "\nBye!\n\n"
    exit 0;
}

function install_system {
    printf "\nInstalling system ...\n"

    sudo cp /etc/apt/sources.list /etc/apt/sources.list.ori
    sudo sed -e 's/ main$/ main contrib non-free/g' -i /etc/apt/sources.list
    sudo apt-get update

    sudo apt-get autoremove --purge -y exim4-.\* portmap rpcbind

    sudo apt-get install -y gnutls-bin sudo git subversion curl rsync emacs emacs-goodies-el php-elisp tree htop sloccount aria2
    sudo apt-get install -y gcc build-essential yasm linux-headers-$(uname -r) libxslt-dev libxml2-dev
    sudo apt-get install -y zip unzip rar p7zip
    sudo apt-get install -y irb python ruby libruby ruby-dev rubygems libmysql-ruby libactiverecord-ruby
    sudo apt-get install -y nmap fail2ban denyhosts tcpdump httperf siege iptraf clamav selinux-basics selinux-policy-default secure-delete

    sudo selinux-activate
}

function install_desktop {
    printf "\nInstalling desktop ...\n"

    sudo apt-get update
    sudo apt-get install -y xorg openbox obconf obmenu tint2 xcompmgr feh rxvt-unicode roxterm
    sudo apt-get install -y lxappearance tango-icon-theme conky grun gksu suckless-tools ttf-bitstream-vera ttf-mscorefonts-installer xscreensaver thunar gigolo gvfs gvfs-backends gvfs-fuse cifs-utils orage
    sudo apt-get install -y libnotify-bin notification-daemon numlockx
    sudo apt-get install -y alsa alsa-tools alsa-oss alsamixergui
    sudo apt-get install -y chromium-browser scrot pidgin xpdf mirage filezilla icedove iceweasel
    sudo apt-get install -y brasero vlc
    sudo apt-get install -y flashplugin-nonfree

    sudo mkdir -p $HOME/.local/share/applications
    if ! [ -f $HOME/.local/share/applications/defaults.list ]; then
        sudo echo "[Default Applications]" > $HOME/.local/share/applications/defaults.list
    fi

    sudo echo "x-directory/gnome-default-handler=Thunar.desktop" >> $HOME/.local/share/applications/defaults.list
    sudo echo "inode/directory=Thunar.desktop" >> $HOME/.local/share/applications/defaults.list
    sudo echo "x-directory/normal=Thunar.desktop" >> $HOME/.local/share/applications/defaults.list
    sudo gpasswd -a $USER fuse

    sudo cp $FILESPATH/fonts.conf $HOME/.fonts.conf
    sudo cp $FILESPATH/Xdefaults $HOME/.Xdefaults
    sudo cp $FILESPATH/Xresources $HOME/.Xresources
    sudo cp $FILESPATH/xinitrc $HOME/.xinitrc
    sudo cp -R $FILESPATH/config $HOME/.config
    sudo cp -R $FILESPATH/Images $HOME/

    sudo chown $USER:$USER $HOME/.fonts.conf
    sudo chown $USER:$USER $HOME/.Xdefaults
    sudo chown $USER:$USER $HOME/.Xresources
    sudo chown $USER:$USER $HOME/.xinitrc
    sudo chown -R $USER:$USER $HOME/.config
    sudo chown -R $USER:$USER $HOME/.local

    sudo Xorg -configure
    sudo alsactl init
}

function install_webserver {
    printf "\nInstalling webserver ...\n"

    sudo mkdir -p /home/www/www
    sudo echo "<?php echo \"WWWelcome\";" > /home/www/www/index.php
    sudo mkdir -p /home/www/logs

#     sudo echo >> /etc/hosts
#     sudo echo "127.0.0.1 local.com www.local.com" >> /etc/hosts

    sudo apt-get install -y apache2 php5 php5-dev php-pear php5-xdebug graphviz php5-mysql php5-pgsql php-gettext php5-cli php5-curl php5-gd php5-mcrypt php-apc postgresql-client mysql-client apachetop libapache-mod-security
    sudo a2enmod rewrite
    sudo a2enmod php5
    sudo a2enmod mod-security
    sudo sed -e 's/ServerTokens\(.*\)$/ServerTokens Prod/g' -i /etc/apache2/conf.d/security
    sudo sed -e 's/ServerSignature\(.*\)$/ServerSignature Off/g' -i /etc/apache2/conf.d/security

    sudo cp /etc/apache2/sites-available/default /etc/apache2/sites-available/default.ori

    sudo cp $FILESPATH/apache-default /etc/apache2/sites-available/default
    sudo cp $FILESPATH/htaccess /home/www/www/.htaccess

    sudo /etc/init.d/apache2 restart

    sudo chown -R $USER:$USER /home/www
}

function install_database {
    printf "\nInstalling database ...\n"

    printf "\n * 1. Install Postgresql\n"
    printf " * 2. Install Mysql\n"

    echo -n "Which one do you want to install ? "
    read CHOICE

    sudo apt-get update

    if [ $CHOICE == "1" ]; then
        sudo apt-get install -y postgresql postgresql-client
    elif [ $CHOICE == "2" ]; then
        sudo apt-get install -y mysql-server mysql-client
    fi
}

function install_pentesting {
    printf "\nInstalling pentesting ...\n"

    sudo apt-get update

    sudo apt-get install -y nmap w3af sqlmap tcpdump tcptrace ettercap dsniff netcat ngrep john kismet siege ratproxy nikto

    sudo apt-get install -y build-essential subversion ruby libruby irb rdoc libyaml-ruby libzlib-ruby libopenssl-ruby libdl-ruby libreadline-ruby libiconv-ruby rubygems sqlite3 libsqlite3-ruby libsqlite3-dev

    svn co http://www.metasploit.com/svn/framework3/trunk /usr/local/metasploit;
    ln -s /usr/local/metasploit/msfconsole /usr/local/bin/msfconsole

    sudo apt-get install -y python-pycurl python-beautifulsoup python-libxml2 python-geoip
    svn co https://xsser.svn.sourceforge.net/svnroot/xsser /usr/local/xsser
    ln -s /usr/local/xsser/xsser /usr/local/bin/xsser
}

function install_virtualbox {
    printf "\nInstalling virtualbox ...\n"

    sudo apt-get update
    sudo apt-get install -y virtualbox-ose virtualbox-ose-dkms
}

function install_config {
    printf "\nInstalling config ...\n"

    sudo cp $FILESPATH/bashrc $HOME/.bashrc
    sudo cp -R $FILESPATH/bin $HOME/

    git clone https://github.com/pierre-lecocq/emacs.d.git $HOME/.emacs.d
    git clone https://github.com/dimitri/el-get.git $HOME/.emacs.d/el-get

    sudo chown $USER:$USER $HOME/.bashrc
    sudo chown -R $USER:$USER $HOME/bin
    sudo chown -R $USER:$USER $HOME/.emacs.d
}

while true; do
    main_menu
    echo -n "What do you want to do ? "
    read CHOICE

    case "$CHOICE" in
        "1") install_system ;;
        "2") install_desktop ;;
        "3") install_webserver ;;
        "4") install_database ;;
        "5") install_pentesting ;;
        "6") install_virtualbox ;;
        "7") install_config ;;
        *) do_exit ;;
    esac
done
