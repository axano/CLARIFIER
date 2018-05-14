#!/bin/bash

discoverSubdomains(){
  echoLog "Starting subdomain discovery..."
  aquatone-discover --domain $1 --threads 10 > /dev/null
  #cp ~/aquatone/$1/hosts.txt $path/reports/$1/
  #remove everything after ','
  sed 's/,.*//' ~/aquatone/$1/hosts.txt >  $path/reports/$1/subdomains.txt
  echoSuccess "Subdomain discovery completed."
}

discoverPorts(){
  echoLog "Starting port discovery..."
  while IFS= read -r line; do
    nmap $line -oN $path/reports/$1/$line/nmapResults.txt > /dev/null
  done < "$path/reports/$1/subdomains.txt"

  echoSuccess "Port discovery completed."
}

discoverHTTPHeaders(){
  echoLog "Starting HTTP header discovery..."
  while IFS= read -r line; do
    curl -I $line -m 1 -L -s> $path/reports/$1/$line/HTTPHeaders.txt
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "HTTP header discovery completed."

}

discoverHTMLOfIndex(){
  echoLog "Starting Index HTML discovery..."
  while IFS= read -r line; do
    curl $line -m 1 -L -s> $path/reports/$1/$line/IndexHTML.txt
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Index HTML discovery completed."

}

discoverURLSInIndex(){
  echoLog "Starting Index URL discovery..."
  while IFS= read -r line; do
    cat $path/reports/$1/$line/IndexHTML.txt | tr \" \\n | grep https\*:// > $path/reports/$1/$line/urlsInIndex.txt
    cat $path/reports/$1/$line/IndexHTML.txt | tr \" \\n | grep http\*:// >> $path/reports/$1/$line/urlsInIndex.txt
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Index URL discovery completed."
}
#cat urls.txt | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq  56
#wget -qO- google.com | tr \" \\n | grep https\*://   63



discoverHTMLComments(){
  echoLog "Starting comment in index discovery..."
  while IFS= read -r line; do
    cat $path/reports/$1/$line/IndexHTML.txt |  awk '/<!--/,/-->/'> $path/reports/$1/$line/htmlComments.
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Comments in index discovery completed."
}
