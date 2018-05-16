#!/bin/bash

#discovers subdomains using aquatone-discover
#if url given as parameter is an ip it will skip the discovery
#aquatone stores the results in ~/aquatone/[domainname]/hosts.txt
#copies the results in subdomains.txt
#silence is achieved using > /dev/null on the end.
#queries multiple domains even domains that are not active anymore
#It will usualy take some time to complete
discoverSubdomains(){
  #result=$(checkIsValidIp $1)
  #if [[ $result -eq 1 ]]; then
  #if  checkIsValidIp $1 ; then
  #echo "$(checkIsValidIp $1)"
  checkIsValidIp $1
  if [ $? -eq 1 ]; then
      echo $1 > $path/reports/$1/subdomains.txt
      echoLog "Skipping domain discovery as parameter is an ip address..."
  else
  echoLog "Starting subdomain discovery. May take a while [avg. 10 min]..."
  aquatone-discover --domain $1 --threads 10 > /dev/null
  #cp ~/aquatone/$1/hosts.txt $path/reports/$1/
  #remove everything after ','
  sed 's/,.*//' ~/aquatone/$1/hosts.txt >  $path/reports/$1/subdomains.txt
  echoSuccess "Subdomain discovery completed."
  fi
}

#Scans for open ports using nmap though only the most well known ports
#Stores the results in nmapResults.txt
discoverPorts(){
  echoLog "Starting port discovery..."
  while IFS= read -r line; do
    nmap $line -oN $path/reports/$1/$line/nmapResults.txt > /dev/null
  done < "$path/reports/$1/subdomains.txt"

  echoSuccess "Port discovery completed."
}

#Queries the index page of the subdomain and stores the http headers it HTTPHeaders.txt
#Uses curl
discoverHTTPHeaders(){
  echoLog "Starting HTTP header discovery..."
  while IFS= read -r line; do
    curl -I $line -m 1 -L -s> $path/reports/$1/$line/HTTPHeaders.txt
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "HTTP header discovery completed."

}

#Queries the index page of the subdomain and stores it in IndexHTML.txt
#Uses curl
discoverHTMLOfIndex(){
  echoLog "Starting Index HTML discovery..."
  while IFS= read -r line; do
    curl $line -m 1 -L -s> $path/reports/$1/$line/IndexHTML.txt
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Index HTML discovery completed."

}

#Filters all urls found in IndexHTML.txt
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


#Stores html comments found in IndexHTML.txt
#works with multiline comments
#captures multiple comments
discoverHTMLComments(){
  echoLog "Starting comment in index discovery..."
  while IFS= read -r line; do
    cat $path/reports/$1/$line/IndexHTML.txt |  awk '/<!--/,/-->/'> $path/reports/$1/$line/htmlComments.txt
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Comments in index discovery completed."
}
#Discovers Server HTTP methods using curl with -X OPTIONS,
#Attention!: OPTIONS method can be disabled while some others aren't
discoverServerMethods(){
  echoLog "Starting server HTTP method discovery..."
  while IFS= read -r line; do
    curl $line -X OPTIONS -m 1 -L -s> $path/reports/$1/$line/serverMethods.txt
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Server HTTP method discovery completed."
}
