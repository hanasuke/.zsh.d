#!/bin/sh

#==========================================================
#  ipaddr_m.sh
#  coded by naosuke
#  2013.07.00
#----------------------------------------------------------
#  変更点
#    2013.09.14 ipが取得できない場合、内蔵NICのMACアドレスを取得
#
#==========================================================

ifconfig | grep en2 > /dev/null

# USB Ethernet Adapterがあるかどうか
if [ $? -eq 0 ]
then
#    echo "ip:"
	ifconfig en2 | grep -v inet6 | grep inet | cut -f 2 -d':' | cut -d' ' -f 2
else 
  ifconfig | grep en0 > /dev/null
  if [ $? -eq 0 ] 
  then
#    echo ip:
 	  ifconfig en0 | grep -v inet6 | grep inet | cut -f 2 -d':' | cut -d' ' -f 2
#    echo "hello"

  else 
#    echo MAC:
   	ifconfig en0 | grep -v inet6 | grep ether | sed -e 's/ether//' | sed -e 's/	//g' | sed -e 's/ //g'
  fi
fi
