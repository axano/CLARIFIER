#!/bin/bash

#Searches for common vulnerabilities using open source database
#Follows redirects but default port is 80
#Is silenced by adding "> /dev/null" on the end
startNikto(){
echoLog "Starting nikto test. May take a while [avg. 1 min]..."
while IFS= read -r line; do
  nikto -h $line -o $path/reports/$1/$line/niktoResults.txt > /dev/null
done < "$path/reports/$1/subdomains.txt"
echoSuccess "Nikto test completed."
}
