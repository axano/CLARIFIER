#!/bin/bash
SCRIPT=`realpath -s $0`
path=`dirname $SCRIPT`
source $path/lib/interface/decoration.sh
source $path/lib/checks/prerequisites.sh
source $path/lib/checks/various.sh
source $path/lib/phases/initialization.sh
source $path/lib/phases/footprinting.sh

localIp=$(hostname -I)
publicIp=$(curl -s http://whatismyip.akamai.com/)


banner
checkPrerequisites
checkInternetConnection
checkArguments "$@"
initialize $1
discoverSubdomains $1
