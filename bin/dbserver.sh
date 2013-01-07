#!/bin/bash

function install_postgresql {
    apt-get install -y postgresql postgresql-client
}

function install_mysql {
    apt-get install -y mysql-server mysql-client
}

echo "Database install launched."
echo -n "Continue ? (y/N) "
read CHOICE

if [[ $CHOICE == "y" ]]; then

    echo
    echo " * 1. Install Postgresql"
    echo " * 2. Install Mysql"
    echo

    echo -n "Which one do you want to install ? "
    read CHOICE

    if [[ $CHOICE == "1" ]]; then
        install_postgresql
    elif [[ $CHOICE == "2" ]]; then
        install_mysql
    fi
fi
