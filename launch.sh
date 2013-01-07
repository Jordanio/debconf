#!/bin/bash

# if [[ $EUID -ne 0 ]]; then
#     echo "   You must be a root user" 2>&1
#     exit 1
# fi

SPATH=`dirname "$(readlink -f "$0")"`

function do_exit {
    echo "Bye!"
    exit 0;
}

function main_menu {
    echo
    echo " * 1. Install basic system"
    echo " * 2. Install desktop (Openbox)"
    echo " * 3. Install web server (Nginx/Apache)"
    echo " * 4. Install database server (Postgresql/Mysql)"
    echo " * 0. Exit"
    echo
}

while true; do
    main_menu
    echo -n "What do you want to do ? "
    read CHOICE

    if [[ $CHOICE == "1" ]]; then
        $SPATH/bin/basic.sh;
    elif [[ $CHOICE == "2" ]]; then
        $SPATH/bin/desktop.sh;
    elif [[ $CHOICE == "3" ]]; then
        $SPATH/bin/webserver.sh;
    elif [[ $CHOICE == "4" ]]; then
        $SPATH/bin/dbserver.sh;
    elif [[ $CHOICE == "0" ]]; then
        do_exit
    fi
done
