#!/bin/bash
# create a new chain
iptables -N mysql-protection
# allow server A
iptables -A mysql-protection --src 11.123.162.66 -j ACCEPT
# allow server B
iptables -A mysql-protection --src 14.156.162.66 -j ACCEPT
# drop everyone else
iptables -A mysql-protection -j DROP
# use chain xxx for packets coming to TCP port 3306
iptables -I INPUT -m tcp -p tcp --dport 3306 -j mysql-protection