#!/bin/bash

SPATH=`dirname "$(readlink -f "$0")"`

function install_directories {
    if ! [ -d /home/www ]; then
        mkdir -p /home/www/www.example.com/public /home/www/static.example.com/public
        mkdir /home/www/logs
        echo "<?php echo \"<p>www</p>\n\";" > /home/www/www.example.com/public/index.php
        echo "<?php echo \"<p>static</p>\n\";" > /home/www/static.example.com/public/index.php
        cp $SPATH/../src/htaccess /home/www/www.example.com/public/.htaccess
        cp $SPATH/../src/htaccess /home/www/static.example.com/public/.htaccess
        echo >> /etc/hosts
        echo "127.0.0.1 example.com www.example.com static.example.com" >> /etc/hosts
        ifdown eth0 && ifup eth0
        ping -c 1 google.com
        ping -c 1 www.example.com
        curl www.example.com
        ping -c 1 static.example.com
        curl static.example.com
        ping -c 1 error.example.com
        curl error.example.com
    fi
}

function install_nginx {
    echo "#DOTDEB REP" >> /etc/apt/sources.list
    echo "deb http://packages.dotdeb.org stable all" >> /etc/apt/sources.list
    echo "deb-src http://packages.dotdeb.org stable all" >> /etc/apt/sources.list
    wget http://www.dotdeb.org/dotdeb.gpg
    cat dotdeb.gpg | apt-key add -
    rm dotdeb.gpg
    apt-get update
    apt-get install -y nginx php5-fpm php5-dev php-pear graphviz php5-mysql php5-pgsql php-gettext php5-cli php5-curl php5-gd php5-mcrypt php-apc postgresql-client mysql-client
    cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.ori
    cp $SPATH/../src/nginx-default /etc/nginx/sites-available/default
    rm -f /home/www/www.example.com/public/.htaccess
    rm -f /home/www/static.example.com/public/.htaccess
    sed -e 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' -i /etc/php5/fpm/pool.d/www.conf
    /etc/init.d/nginx restart
    /etc/init.d/php5-fpm restart
    rm -f /home/www/www.example.com/public/.htaccess
}

function install_apache2 {
    apt-get install -y apache2 php5 php5-dev php-pear  php5-xdebug graphviz php5-mysql php5-pgsql php-gettext php5-cli php5-curl php5-gd php5-mcrypt php-apc postgresql-client mysql-client
    a2enmod rewrite
    a2enmod php5
    sed -e 's/ServerTokens\(.*\)$/ServerTokens Prod/g' -i /etc/apache2/conf.d/security
    sed -e 's/ServerSignature\(.*\)$/ServerSignature Off/g' -i /etc/apache2/conf.d/security
    cp /etc/apache2/sites-available/default /etc/apache2/sites-available/default.ori
    cp $SPATH/../src/apache2-default /etc/apache2/sites-available/default
    /etc/init.d/apache2 restart
}

echo "Webserver install launched."
echo -n "Continue ? (y/N) "
read CHOICE

if [[ $CHOICE == "y" ]]; then

    echo
    echo " * 1. Install Nginx"
    echo " * 2. Install Apache2"
    echo

    echo -n "Which one do you want to install ? "
    read CHOICE

    install_directories

    if [[ $CHOICE == "1" ]]; then
        install_nginx
    elif [[ $CHOICE == "2" ]]; then
        install_apache2
    fi
fi
