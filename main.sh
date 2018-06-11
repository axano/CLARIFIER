#!/bin/bash
SCRIPT=`realpath -s $0`
path=`dirname $SCRIPT`

#####IMPORTS
#Priority matters and imports have to come after path and SCRIPT variables
source $path/lib/interface/decoration.sh
source $path/lib/interface/commandMonitoring.sh
source $path/lib/uncategorized/housekeeping.sh
source $path/lib/checks/prerequisites.sh
source $path/lib/checks/internet.sh
source $path/lib/checks/system.sh
source $path/lib/checks/arguments.sh
source $path/lib/phases/initialization.sh
source $path/lib/phases/footprinting.sh
source $path/lib/phases/advancedFootprinting.sh
source $path/lib/phases/reconnaissance.sh

#####GLOBAL VARIABLES

localIp=$(hostname -I)
publicIp=$(curl -s http://whatismyip.akamai.com/)
debug=0
######VARIABLES INITIALIZED BY ARGUMENTS
domainToTest=''
singleUrl=0
verbosity=1
doInternetRelatedTests=1
######START OF PROGRAM

### START PREQUEL ###
#prints banner
banner
#checks argument validity and initializes global variables with the arguments
checkAndParseArguments "$@"

#checks if script is run under root context
checkIsRoot

#checks if all used programs are installed using 'which'
checkPrerequisites

#checks internet connection by using wget on 1.1.1.1
checkInternetConnection

#checks if global variable domainToTest is unreachable
#domainToTest can be  an IP or a domain
#validity is tested in checkAndParseArguments
#check is done with  wget -q --spider
checkIsUrlReachable $domainToTest

#creates a folder with the url name passed as argument in the reports folder
#while checking if the folder already exist and checks if the folder is created
initialize $domainToTest

### END PREQUEL ###

#initialize start time to calculate time taken to run main test
start=`date +%s`

### START MAIN TEST

## START SIMPLE TESTS

#discovers available subdomains using aquatone-discover in silent mode
#through /dev/null piping the output,
#if url given as parameter is an ip
#or if the -s argument is given
#it will skip the subdomain discovery
#the scan output is stored in in ~/aquatone/[url]/hosts.txt
#and is then parsed to /reports/[url]/subdomains.txt using sed
discoverSubdomains $domainToTest

#creates a folder for every subdomain to store the report for each one of them
initializeFolderForEverySubdomain $domainToTest

#discovers open ports using nmap (only the most well known)
discoverPorts $domainToTest

#Gets the http headers using curl -I -m 1 -L -s
discoverHTTPHeaders $domainToTest

#Gets supported http methods using curl -X OPTIONS -I -m 1 -L -s
#(TODO script a request with all possible methods and parse results)
#(TODO some servers dissalow OPTIONS but still allow other methods)
discoverServerMethods $domainToTest

#Gets the http content using curl -m 1 -L -s
discoverHTMLOfIndex $domainToTest

#Gets the contents of robots.txt if there is one
#(TODO parse results if 404 is returned)
reconRobotsTxt $domainToTest

#Gets the contents of robots.txt if there is one
#(TODO parse results if 404 is returned)
reconHumansTxt $domainToTest

#grabs a screenshot of every subdomain using cutycapt
#(TODO optimize screenshot width)
reconIndexScreenshot $domainToTest

#filters all urls that are present in the html of index only
#(TODO cascade search all urls )
discoverURLSInIndex $domainToTest

#filters html comments that are present in the html of index only
discoverHTMLComments $domainToTest


## END SIMPLE TESTS

## START ADVANCED TESTS
discoverWAF $domainToTest
#searches for common vulnerabilities with nikto
#takes some time to complete
startNikto $domainToTest

#Discovers directory structure of all subdomains
#Uses dirb with the standard wordlist "/usr/share/dirb/wordlists/common.txt" (kali)
#(BUG BUG BUG)
#(BUG) by not determining if the endpoint works with https or plain http
#(BUG) dirb fails.
#(BUG BUG BUG)
discoverDirectoryStructure $domainToTest

## END ADVANCED TESTS


### END MAIN TEST

#initialize end date to calculate time taken to run main test
end=`date +%s`
echoTotalTimeTaken
