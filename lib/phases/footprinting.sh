#!/bin/bash

discoverSubdomains(){
  echoLog "Starting subdomain discovery..."
  aquatone-discover --domain $1 --threads 10
  #cp ~/aquatone/$1/hosts.txt $path/reports/$1/
  #remove everything after ','
  sed 's/,.*//' >  $path/reports/$1/subdomains.txt
}
