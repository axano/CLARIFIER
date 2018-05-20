#!/bin/bash

#Checks if there is an internet connection using wget and querries 1.1.1.1
#Check is necessary because internet is needed to check if the domain is valid.
checkInternetConnection(){
  echoLog "Checking internet connection..." 2
  wget -q --spider 1.1.1.1
  if [ $? -eq 0 ]; then
      echoSuccess "Connection online." 1
  else
      echoError "No internet detected." 0
      myExit
  fi
}

#Checks if the domain given with -d parameter is valid by using host.
#host will return true if there is a dns record for a domain
#as well as a reverse pointer for a given ip
checkIsValidDomain(){
  echoLog "Checking if parameter is a valid domain..." 2
  host $1  &> /dev/null
    if [ $? -eq 0 ]
    then
        echoSuccess "Parameter is a valid domain."  1
        return 1
    else
        echoLog "Parameter is not a valid domain."  2
        return 0
    fi
}

#Works good there is only one small bug where leading '-' is accepted
#E.X
#192.168.1.1 OK
#192.168.1.0 OK
#192.168.1.-1 NOK
#-192.168.1.-1 NOK
#-192.168.1.1 NOK
#192.168.1.255.8 NOK 
checkIsValidIp(){
  echoLog "Checking if $1 is a valid IP address..." 2
  test='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
  if [[ $1 =~ ^$test\.$test\.$test\.$test$ ]]; then
    echoSuccess "$1 is a valid IP address..." 1
    return 1
  else
    echoLog "$1 is not a valid IP address..." 2
    return 0
  fi
}

#Checks if the argument is reachable through internet using wget -q --spider
#Check is necessary because internet is needed to check if the domain is valid.
checkIsUrlReachable(){
  echoLog "Checking if $1 is reachable..." 2
  wget -q --spider $1
  if [ $? -eq 0 ]; then
      echoSuccess "$1 is reachable." 1
  else
      echoError "$1 is unreachable." 0
      myExit
  fi

}
