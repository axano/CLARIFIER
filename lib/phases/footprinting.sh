#!/bin/bash

discoverSubdomains(){
  echoLog "Starting subdomain discovery..."
  aquatone-discover --domain $1
  cp ~/aquatone/$1/hosts.txt $path/reports/$1/
  
}
