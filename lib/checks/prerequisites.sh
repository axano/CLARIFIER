#!/bin/bash

checkPrerequisites(){
#array with prerequisites
preReqs=(
   'aquatone-discover'
   'wget'
   'nmap'
   'curl'
   'cutycapt'
   'sed'
   'awk'
   'host'
   #'getopts' #is builtin
   #'dummy' #dummy prereq to test controls
   #'npm'
   #'nodejs'
)
echo ''
echoLog "Checking prerequisites..."
allOK=true
for i in "${preReqs[@]}"
do :
   condition=$(which $i 2>/dev/null | grep -v "not found" | wc -l)
   if [ $condition -eq 0 ] ; then
     echoError "$i is not installed."
     allOK=false
   else
     echoSuccess "$i is installed."
  fi
done
if [ "$allOK" = false ]; then
  echoError "Not all prerequisites are installed."
  echoError "Please read the manual to find installation instructions."
  echo ""
  cat "$path/manual.txt"
  echo ""
  echoError "Exiting..."
  exit 1
fi
}
