#!/bin/bash

echo
# --

l=`VBoxManage list vms | grep -v List | grep -v Oracle | grep -v All | cut -f1 -d' ' | tr "\"" " " | tr "\n" "    "`
if ! [[ -z $l ]]; then
    echo "Available VMs : $l"
fi

l=`VBoxManage list runningvms | grep -v List | grep -v Oracle | grep -v All | cut -f1 -d' ' | tr "\"" " " | tr "\n" "    "`
if ! [[ -z $l ]]; then
    echo "Running VMs : $l"
fi

#

echo
vm_type="headless"
if [ $# -gt 0 ]; then
    action=$1
    vm_name=$2
    if ! [ -z $3 ]; then vm_type=$3; fi


    echo "Launching $vm_name $vm_type ..."
    case $action in
    "start")
        VBoxManage startvm $vm_name --type $vm_type && logger "VM started : $vm_name"
        ;;
    "stop")
        VBoxManage controlvm $vm_name poweroff
        ;;
    *) ;;
    esac

else
    echo "Usage :"
    echo "$0 <start|stop> vmname [ type: headless | gui ]"
fi
echo
exit 1
