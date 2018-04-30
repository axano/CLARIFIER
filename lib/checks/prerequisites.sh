#!/bin/bash

checkPrerequisites(){
#array with prerequisites
preReqs=(
   'aquatone-discover'


)
echo ''
for i in "${preReqs[@]}"
do :

   condition=$(which $i 2>/dev/null | grep -v "not found" | wc -l)
   if [ $condition -eq 0 ] ; then
     echo -e "\e[0;31m[-]$i is not installed\e[m"
   else
     echo "[+]$i is installed"
  fi
done
}
