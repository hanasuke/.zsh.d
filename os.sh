#!/bin/sh

#uname > /dev/null

if [ `uname` = "Darwin" ] 
then
    ./ipaddr_m.sh
elif [ `uname` = "Linux" ]
 then
    ./ipaddr_l.sh
fi
