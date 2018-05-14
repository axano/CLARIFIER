#!/bin/bash
SCRIPT=`realpath -s $0`
path=`dirname $SCRIPT`
source $path/lib/interface/decoration.sh
source $path/lib/checks/prerequisites.sh
source $path/lib/checks/various.sh
source $path/lib/phases/initialization.sh
source $path/lib/phases/footprinting.sh
source $path/lib/phases/reconnaissance.sh
localIp=$(hostname -I)
publicIp=$(curl -s http://whatismyip.akamai.com/)

: ''
#prints banner
banner
#checks if all used programs are installed using 'which'
checkPrerequisites
#checks internet connection by using wget on 1.1.1.1
checkInternetConnection
#checks if the count of arguments is not equal to 0
#(TODO check if arg is a valid url and add multiple options)
checkArguments "$@"
#creates a folder with the url name passed as argument in the reports folder
#while checking if the folder already exist and checks if the folder is created
initialize $1
#discovers available subdomains using aquatone-discover in silent mode
#through /dev/null piping the output,
#the scan output is stored in in ~/aquatone/[url]/hosts.txt
#and is then parsed to /reports/[url]/subdomains.txt using sed
discoverSubdomains $1
#creates a folder for every subdomain to store the report for each one of them
initializeFolderForEverySubdomain $1
#discovers open ports using nmap (only the most well known)
discoverPorts $1
#Gets the http headers using curl -I -m 1 -L -s
discoverHTTPHeaders $1
#Gets the http content using curl -m 1 -L -s
discoverHTMLOfIndex $1
#Gets the contents of robots.txt if there is one
#(TODO parse results if 404 is returned)
reconRobotsTxt $1
#grabs a screenshot of every subdomain using cutycapt
#(TODO optimize screenshot width)
reconIndexScreenshot $1
#filters all urls that are present in the html of index only
#(TODO cascade search all urls )
discoverURLSInIndex $1
