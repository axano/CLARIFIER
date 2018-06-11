#!/bin/bash

#Searches for common vulnerabilities using open source database
#Follows redirects but default port is 80
#Is silenced by adding "> /dev/null" on the end
#This while loop that reads entries from file uses the file descriptor alternative
#as the classic version used over the whole project interfered with nikto
#(TODO) redirect stderror to echoError
#while IFS= read -r line; do >>>>>>>> refactored this function as the old method
#didnt use file a descriptor with as consequence that
#nikto consumed all the entries of the file from stdin
#(NOTE)if both 80 and 443 ports are specified it will take twice as long to complete
#(TODO) check if https url give different results and patch if so
startNikto(){
echoLog "Starting nikto test. May take a while [avg. 10 min for each subdomain]..." 1
while read -u "$subdomains_fd" -r line; do
  echoLog "Testing $line with nikto..." 3
  #nikto -h $line -port 80,443 -o $path/reports/$1/$line/niktoResults.txt  > /dev/null
  executeAndMonitorStatus "nikto -h $line -port 80,443 -o $path/reports/$1/$line/niktoResults.txt  > /dev/null"
done {subdomains_fd}<"$path/reports/$1/subdomains.txt"
echoSuccess "Nikto test completed." 1
}

#Discovers the directory structure of a given urls
#The standard wordlist is "/usr/share/dirb/wordlists/common.txt" (kali)
#(NOTE) gives error if executed with http:// if the server uses https
#thats why the test for HTTPS is done.
#(TODO) detect the site technology used to adapt the extension to test (-X parameter)
#E.g -X .html
#argument -r skips recursive search to make the scan faster.
#(TODO) add script argument to give the user the option to DO a recursive search.
discoverDirectoryStructure(){
  echoLog "Starting directory structure discovery. May take a while [avg. 5 min for each subdomain]..." 1
  #while IFS= read -r line; do
  while read -u "$subdomains_fd" -r line; do
    echoLog "Discovering directory structure of $line..." 3
    checkHTTPS $line
    if [ $? -eq 1 ]; then
      #dirb https://$line -o $path/reports/$1/$line/directoryStructure.txt &> /dev/null
      executeAndMonitorStatus "dirb https://$line -o $path/reports/$1/$line/directoryStructure.txt -r &> /dev/null"
    else
      #dirb http://$line -o $path/reports/$1/$line/directoryStructure.txt &> /dev/null
      executeAndMonitorStatus "dirb http://$line -o $path/reports/$1/$line/directoryStructure.txt -r &> /dev/null"
    fi

  #done < "$path/reports/$1/subdomains.txt"
  done {subdomains_fd}<"$path/reports/$1/subdomains.txt"
  echoSuccess "Directory structure discovery completed." 1
}

#Tries to detect if the target host is protected by a WebApplicationFirewall
#uses wafw00f.
#filters for the string "behind"
discoverWAF(){
  echoLog "Starting WAF discovery..." 1
  while read -u "$subdomains_fd" -r line; do
    echoLog "WAF discovery for $line..." 3
      output="$(wafw00f $line  | grep behind)"
      #following line is needed to see if the output of wafw00f contains the word "behind"
      #and it has to be the lastt line executed before the if case
      echo "${output}" | grep -q behind
      if [ $? -eq 0 ]; then
        echoError "$output." 1
        echoError "therefore, tests done around injection (XSS,SQLi,HTMLi) will probably be lost time. " 2
      else
        echoSuccess "$line does not seem to behind some kind of WAF or some sort of security solution." 2
      fi
  done {subdomains_fd}<"$path/reports/$1/subdomains.txt"
}
