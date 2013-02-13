#!/bin/bash

# http://www.debian-tutorials.com/iptables-shell-script-to-drop-spamhaus-listed-ip

IPT=`which iptables`
FILE="/tmp/drop.lasso"
URL="http://www.spamhaus.org/drop/drop.lasso"

# This will delete all dropped ips from firewall
ipdel=$(cat $FILE  | egrep -v '^;' | awk '{ print $1}')

for ipblock in $ipdel
do
    $IPT -D spamhaus-droplist -s $ipblock -j DROP
    $IPT -D droplist -s $ipblock -j LOG –log-prefix "DROP Spamhaus List"
done

# This will drop all ips from spamhaus list.
[ -f $FILE ] && /bin/rm -f $FILE || :
cd /tmp
wget $URL

blocks=$(cat $FILE  | egrep -v '^;' | awk '{ print $1}')
$IPT -N spamhaus-droplist

for ipblock in $blocks
do
    $IPT -A droplist -s $ipblock -j LOG –log-prefix "DROP Spamhaus List"
    $IPT -A droplist -s $ipblock -j DROP
done

$IPT -I INPUT -j droplist
$IPT -I OUTPUT -j droplist
$IPT -I FORWARD -j droplist
