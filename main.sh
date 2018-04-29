#!/bin/bash
SCRIPT=`realpath -s $0`
path=`dirname $SCRIPT`
source $path/lib/interface/decoration.sh

localIp=$(hostname -I)
publicIp=$(curl -s http://whatismyip.akamai.com/)

banner
