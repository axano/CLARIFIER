#!/bin/bash

#Checks argument validity parses every variable to
#the corresponding global variable
# {BUG} -d parameter is necessary but not check is done if it is present
checkAndParseArguments(){
  echoLog "Checking arguments..."
  if [ "$#" -lt 1 ]; then
    echoError "No arguments found"
    cat "$path/usage.txt"
    myExit
  fi
  while getopts ":hd:" opt; do
  case $opt in
    d)
      echoSuccess "-d was triggered!" >&2
      #result=$(checkIsValidDomain $OPTARG)
      #if [ $result -eq 1 ]; then
      #if checkIsValidDomain $OPTARG ; then
      checkIsValidDomain $OPTARG
      if [ $? -eq 1 ]; then
          domainToTest=$OPTARG
      else
        #result=$(checkIsValidIp $OPTARG)
        #if [ $result -eq 1 ]; then
        #if checkIsValidIp $OPTARG ; then
        checkIsValidIp $OPTARG
        if [ $? -eq 1 ]; then
            domainToTest=$OPTARG
        else
          echoError "Invalid domain/IP."
          myExit
        fi
      fi
      ;;
    h)
      echoSuccess "-h was triggered!" >&2
      cat "$path/usage.txt"
      myExit
      ;;
    :)
      echoError "Option -$OPTARG requires an argument." >&2
      cat "$path/usage.txt"
      myExit
      ;;
    \?)
      echoError "Invalid option: -$OPTARG" >&2
      cat "$path/usage.txt"
      myExit
      ;;
  esac
done
echoSuccess "Arguments checked."
}
