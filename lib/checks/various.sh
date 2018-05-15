#!/bin/bash
#Checks script is running as root
checkIsRoot()
{
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
}

#Checks argument validity parses every variable to
#the corresponding global variable
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
      result=$(checkIsValidDomain $OPTARG)
      if [[ $result -eq 1 ]]; then
          domainToTest=$OPTARG
      else
        echoError "Invalid domain or domain cannot be reached."
        myExit
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
echoSuccess "Arguments OK."
}
#Checks if there is an internet connection using wget and querries 1.1.1.1
#Check is necessary because internet is needed to check if the domain is valid.
checkInternetConnection(){
  echoLog "Checking internet connection..."
  wget -q --spider 1.1.1.1
  if [ $? -eq 0 ]; then
      echoSuccess "Connection online."
  else
      echoError "No internet detected."
      myExit
  fi
}

#Checks if the domain given with -d parameter is valid by using host.
#host will return true if there is a dns record for a domain
#as well as a reverse pointer for a given ip
checkIsValidDomain(){
  host $1 2>&1 > /dev/null
    if [ $? -eq 0 ]
    then
        echo 1
    else
        echo 0
    fi
}
