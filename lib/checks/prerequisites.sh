#!/bin/bash

checkPrerequisites(){
#array with prerequisites
preReqs=(
   'aquatone-discover'
   'wget'

)
echo ''
echoLog "Checking prerequisites..."
for i in "${preReqs[@]}"
do :

   condition=$(which $i 2>/dev/null | grep -v "not found" | wc -l)
   if [ $condition -eq 0 ] ; then
     echoError "$i is not installed."
   else
     echoSuccess "$i is installed."
  fi
done
}
