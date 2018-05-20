#!/bin/bash
#checks prerequisites using which and prints installation manual
#if there are uninstalled prerequisites
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
   'dirb'
   #'getopts' #is builtin
   #'dummy' #dummy prereq to test controls
   #'npm'
   #'nodejs'
)
echoLog "Checking prerequisites..." 2
allOK=true
for i in "${preReqs[@]}"
do :
   condition=$(which $i 2>/dev/null | grep -v "not found" | wc -l)
   if [ $condition -eq 0 ] ; then
     echoError "$i is not installed." 0
     allOK=false
   else
     echoSuccess "$i is installed." 2
  fi
done
if [ "$allOK" = false ]; then
  echoError "Not all prerequisites are installed." 0
  echoError "Please read the manual to find installation instructions." 0
  echo ""
  cat "$path/manual.txt"
  echo ""
  myExit
fi
}
