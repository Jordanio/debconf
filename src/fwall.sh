#!/bin/sh

IPTBIN=`which iptables`
IP="10.14.1.85"

# Fuck 'em all
$IPTBIN -F
$IPTBIN -X
$IPTBIN -P INPUT DROP
$IPTBIN -P OUTPUT DROP
$IPTBIN -P FORWARD DROP
$IPTBIN -A INPUT -i lo -j ACCEPT
$IPTBIN -A OUTPUT -o lo -j ACCEPT

for port in 22 80; do
    echo "Open port $port"
    $IPTBIN -A INPUT -p tcp -s 0/0 -d $IP --sport 513:65535 --dport $port -m state --state NEW,ESTABLISHED -j ACCEPT
    $IPTBIN -A OUTPUT -p tcp -s $IP -d 0/0 --sport $port --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT
done

# Nothing must go out
$IPTBIN -A INPUT -j DROP
$IPTBIN -A OUTPUT -j DROP
