#!/bin/bash

#Searches for common vulnerabilities using open source database
#Follows redirects but default port is 80
#Is silenced by adding "> /dev/null" on the end
#This while loop that reads entries from file uses the file descriptor alternative
#as the classic version used over the whole project interfered with nikto
startNikto(){
echoLog "Starting nikto test. May take a while [avg. 10 min]..."

#while IFS= read -r line; do >>>>>>>> refactored this function as the old method
#didnt use file a descriptor with as consequence that
#nikto consumed all the entries of the file from stdin
while read -u "$subdomains_fd" -r line; do

  echoLog "Testing $line with nikto..."
  nikto -h $line -o $path/reports/$1/$line/niktoResults.txt  > /dev/null

done {subdomains_fd}<"$path/reports/$1/subdomains.txt"

echoSuccess "Nikto test completed."
}
