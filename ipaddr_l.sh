#!/bin/sh
if [ `/sbin/ifconfig | grep eth2`]; then
/sbin/ifconfig eth1 | grep inet | grep -v inet6 | cut -f 2 -d':' | cut -d' ' -f 1
else
/sbin/ifconfig eth0 | grep inet | grep -v inet6 | cut -f 2 -d':' | cut -d' ' -f 1
fi
