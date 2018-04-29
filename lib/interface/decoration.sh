#!/bin/bash
#This colour
cyan='\e[0;36m'
green='\e[0;32m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[1;33m'
blue='\e[1;34m'
resetCollor='\e[m'


fancyEcho()
{
collors=(
	'\e[0;36m'
	'\e[0;32m'
	'\e[1;32m'
	'\e[1;31m'
	'\e[1;37m'
	'\e[1;33m'
	'\e[1;34m'
	'\e[1;35m'
)
string=$1
for word in $string;
do
#arr=(`echo ${string}`);
arr=( $(echo ${word} | sed "s/\(.\)/\1 /g") )
for i in "${arr[@]}"
    do
	collor=${collors[$RANDOM % ${#collors[@]} ]}
	echo -ne $collor$i$resetCollor
	sleep 0.06
done
echo -n " "
done
#echo -ne "\n"
unset IFS
}

banner()
{
clear
cat << "EOF"


__________-------____                 ____-------__________
\------____-------___--__---------__--___-------____------/
 \//////// / / / / / \   _-------_   / \ \ \ \ \ \\\\\\\\/
   \////-/-/------/_/_| /___   ___\ |_\_\------\-\-\\\\/
     --//// / /  /  //|| (O)\ /(O) ||\\  \  \ \ \\\\--
          ---__/  // /| \_  /V\  _/ |\ \\  \__---
               -//  / /\_ ------- _/\ \  \\-
                 \_/_/ /\---------/\ \_\_/
                     ----\   |   /----
                          | -|- |
                         /   |   \
                        |___/ \___|


EOF

fancyEcho "Web Pentesting Framework brought to you AXANO"
echo
}
