#!/bin/bash

#Searches for common vulnerabilities using open source database
#Follows redirects but default port is 80
#Is silenced by adding "> /dev/null" on the end
#This while loop that reads entries from file uses the file descriptor alternative
#as the classic version used over the whole project interfered with nikto
#(TODO) redirect stderror to echoError
startNikto(){
#while IFS= read -r line; do >>>>>>>> refactored this function as the old method
#didnt use file a descriptor with as consequence that
#nikto consumed all the entries of the file from stdin
#(TODO) check if https url give different results and patch if so
echoLog "Starting nikto test. May take a while [avg. 10 min]..." 2
while read -u "$subdomains_fd" -r line; do
  echoLog "Testing $line with nikto..." 3
  nikto -h $line -port 80,443 -o $path/reports/$1/$line/niktoResults.txt  > /dev/null
done {subdomains_fd}<"$path/reports/$1/subdomains.txt"
echoSuccess "Nikto test completed." 1
}

#Discovers the directory structure of a given urls
#(DIRTY SOLLUTION) appended 'http://' to all urls read
#any http calls to https servers will be redirected anyway.
#The standard wordlist is "/usr/share/dirb/wordlists/common.txt" (kali)
#(TODO) detect the site technology used to adapt the extension to test (-X parameter)
#E.g -X .html
discoverDirectoryStructure(){
  echoLog "Starting directory structure discovery..." 2
  while IFS= read -r line; do
    echoLog "Discovering directory structure of $line..." 3
    dirb http://$line -o $path/reports/$1/$line/directoryStructure.txt &> /dev/null
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Directory structure discovery completed." 1
}
