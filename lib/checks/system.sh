#!/bin/bash

#Checks script is running as root
checkIsRoot()
{
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echoError "This script must be run as root" 0
   myExit
fi
}
