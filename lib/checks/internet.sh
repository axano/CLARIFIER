#!/bin/bash

#Checks if there is an internet connection using wget and querries 1.1.1.1
#Check is necessary because internet is needed to check if the domain is valid.
checkInternetConnection(){
  if [ $doInternetRelatedTests -eq 1 ]; then
    echoLog "Checking internet connection..." 2
    wget -q --spider 1.1.1.1
    if [ $? -eq 0 ]; then
        echoSuccess "Connection online." 2
    else
        echoError "No internet detected." 0
        myExit
    fi
  else
    echoLog "Skipping internet connectivity test..." 3
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
        echoSuccess "Parameter is a valid domain."  2
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
    echoSuccess "$1 is a valid IP address..." 2
    return 1
  else
    echoLog "$1 is not a valid IP address..." 2
    return 0
  fi
}

#Checks if the argument is reachable through internet using wget -q --spider
#Check is necessary because internet is needed to check if the domain is valid.
checkIsUrlReachable(){
  if [ $doInternetRelatedTests -eq 1 ]; then
    echoLog "Checking if $1 is reachable..." 2
    wget -q --spider $1
    if [ $? -eq 0 ]; then
        echoSuccess "$1 is reachable." 2
    else
        echoError "$1 is unreachable." 0
        echoError "If you are sure that the host is online add -c to the arguments." 0
        myExit
    fi
  else
    echoLog "Skipping url reachability test..." 3
  fi
}

#(NOTE)
#Checks if the server has port 443 open to determine if it uses https
#-oG flag of nmap makes it greppable
#-q flag of grep silences the output
#(WARNING) grep returns zero if string is found so it has to be inverted.
#and nothing if string wasnt found
checkHTTPS(){
  echoLog "Checking if $1 uses HTTPS or HTTP..." 2
  nmap -oG - -p 443 $1 | grep -q "open"
  result=$?
  if [ $result -eq 0 ]; then
    echoSuccess "$1 probably uses HTTPS as port 443 is open." 3
    return 1
  else
    echoLog "$1 does not use HTTPS or hosts service on port other than 443." 3
    return 0
  fi
}

checkConnectionQuality(){
  if [ $doInternetRelatedTests -eq 1 ]; then
    echoLog "Checking connection quality..." 2

  else
    echoLog "Skipping connection quality test..." 3
  fi
}
