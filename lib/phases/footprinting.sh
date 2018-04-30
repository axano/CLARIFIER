#!/bin/bash

discoverSubdomains(){
  echoLog "Starting subdomain discovery..."
  aquatone-discover --domain $1 --threads 10
  #cp ~/aquatone/$1/hosts.txt $path/reports/$1/
  #remove everything after ','
  sed 's/,.*//' ~/aquatone/$1/hosts.txt >  $path/reports/$1/subdomains.txt
  echoSuccess "Subdomain discovery completed."
}

discoverPorts(){
  echoLog "Starting port discovery..."
  while IFS= read -r line; do
    #do $line
    nmap $line > $path/reports/$1/$line/nmapResults.txt
  done < "$path/reports/$1/subdomains.txt"

  echoSuccess "Port discovery completed."
}

discoverHTTPHeaders(){
  echoLog "Starting HTTP header discovery..."
  while IFS= read -r line; do
    #do $line
    curl -I $line > $path/reports/$1/$line/nmapResults.txt
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "HTTP header discovery completed."

}
