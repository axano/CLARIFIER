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

#Prints message if verbosity level needed is less or equal to the global verbosity level
# $1 is the message $2 is the verbosityLevelNeeded and $verbosity is the global variable verbosity
# initialized by the arguments.sh script
#the program should be called in the following way
#echoSuccess $message $verbosityLevelNeeded
#that means that an important message will need a lesser verbosity level to be printed
echoSuccess(){
	if [[ $2 -le $verbosity ]]; then
		now=$(date +"%H:%M":%S)
		echo -e "\e[0;32m[ $now ] $1\e[m"
	fi
}

#Prints message if verbosity level needed is less or equal to the global verbosity level
# $1 is the message $2 is the verbosityLevelNeeded and $verbosity is the global variable verbosity
# initialized by the arguments.sh script
#the program should be called in the following way
#echoLog $message $verbosityLevelNeeded
#that means that an important message will need a lesser verbosity level to be printed
echoLog(){
	if [[ $2 -le $verbosity ]]; then
		now=$(date +"%H:%M":%S)
		echo -e "\e[0;33m[ $now ] $1\e[m"
	fi

}

#Prints message if verbosity level needed is less or equal to the global verbosity level
# $1 is the message $2 is the verbosityLevelNeeded and $verbosity is the global variable verbosity
# initialized by the arguments.sh script
#the program should be called in the following way
#echoError $message $verbosityLevelNeeded
#that means that an important message will need a lesser verbosity level to be printed
echoError(){
	if [[ $2 -le $verbosity ]]; then
		now=$(date +"%H:%M":%S)
		echo -e "\e[0;31m[ $now ] $1\e[m"
	fi
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

fancyEcho "Web Pentesting Framework brought to you by AXANO"
echo ''
echo ''
}
