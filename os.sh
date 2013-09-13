#!/bin/sh

#uname > /dev/null

if [ `uname` = "Darwin" ] 
then
    ~/.zsh.d/ipaddr_m.sh
elif [ `uname` = "Linux" ]
 then
    ~/.zsh.d/ipaddr_l.sh
fi
