#!/bin/bash
# create a new chain
iptables -N redis-protection
# allow server A
iptables -A redis-protection --src 11.123.162.66 -j ACCEPT
# allow server B
iptables -A redis-protection --src 14.156.162.66 -j ACCEPT
# drop everyone else
iptables -A redis-protection -j DROP
# use chain xxx for packets coming to TCP port 6379
iptables -I INPUT -m tcp -p tcp --dport 6379 -j redis-protection