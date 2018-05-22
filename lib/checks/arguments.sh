#!/bin/bash

#Checks argument validity parses every variable to
#the corresponding global variable
#(TODO) NEEDS TO BE REFACTORED
checkAndParseArguments(){
  echoLog "Checking arguments..." 2
  if [ "$#" -lt 1 ]; then
    echoError "No arguments found" 0
    cat "$path/usage.txt"
    myExit
  fi
  #: before argument does not take value e.x :s
  #: after argument requires value e.x d:
  while getopts ":c :s :h d: v:" opt; do
  case $opt in
    d)
    #initializes the domain that has to be scanned
    #validation happens on the end of checkAndParseArguments()
      domainToTest=$OPTARG
      ;;
    #parameter that initializes the verbosity level
    #standard verbosity level is 1 which means only error and success messages
    v)
    if [ $OPTARG -ge 0 -a $OPTARG -le 3 ]; then
      verbosity=$OPTARG
    else
      echoError "Invalid verbosity level." 0
      cat "$path/usage.txt"
      myExit
    fi
      ;;
    s)
      singleUrl=1
      ;;
    h)
      cat "$path/usage.txt"
      myExit
      ;;
    c)
      echoDebug "-c triggered"
      doInternetRelatedTests=0
      ;;
    :)
      echoError "Option -$OPTARG requires an argument." 0
      cat "$path/usage.txt"
      myExit
      ;;
    \?)
      echoError "Invalid option: -$OPTARG" 0
      cat "$path/usage.txt"
      myExit
      ;;
  esac
done
if [ "$domainToTest" == '' ]; then
  echoError "-d option is mandatory" 0
  cat "$path/usage.txt"
  myExit
fi
#ARGUMENT VALIDATION START
checkIsValidDomain $domainToTest
if [ $? -ne 1 ]; then
    checkIsValidIp $domainToTest
    if [ $? -ne 1 ]; then
      echoError "Invalid domain/IP." 0
      myExit
    fi
fi
#ARGUMENT VALIDATION END
echoSuccess "Arguments checked and parsed." 1
}
