#!/bin/bash

discoverSubdomains(){

  aquatone-discover --domain $1
  cp ~/aquatone/$1/hosts.txt $path/reports/$1/

}
