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
  if [ $? -eq 1 ] || [ "$singleUrl" -eq '1' ]; then
      echo $1 > $path/reports/$1/subdomains.txt
      echoLog "Skipping subdomain discovery..." 3
  else
  echoLog "Starting subdomain discovery. May take a while [avg. 10 min]..." 2
  aquatone-discover --domain $1 --threads 10 > /dev/null
  #cp ~/aquatone/$1/hosts.txt $path/reports/$1/
  #remove everything after ','
  sed 's/,.*//' ~/aquatone/$1/hosts.txt >  $path/reports/$1/subdomains.txt
  echoSuccess "Subdomain discovery completed." 1
  fi
}
#Scans for open ports using nmap though only the most well known ports
#Stores the results in nmapResults.txt
discoverPorts(){
  echoLog "Starting port discovery..." 2
  while IFS= read -r line; do
    echoLog "Discovering ports of $line..." 3
    #nmap $line -oN $path/reports/$1/$line/nmapResults.txt > /dev/null
    executeAndMonitorStatus "nmap $line -oN $path/reports/$1/$line/nmapResults.txt > /dev/null"
    echoLog "Port discovery of $line done." 3
  done < "$path/reports/$1/subdomains.txt"

  echoSuccess "Port discovery completed." 1
}

#Queries the index page of the subdomain and stores the http headers it HTTPHeaders.txt
#Uses curl
discoverHTTPHeaders(){
  echoLog "Starting HTTP header discovery..." 2
  while IFS= read -r line; do
    echoLog "Disvovering HTTP headers of $line ..." 3
    curl -I $line -m 1 -L -s> $path/reports/$1/$line/HTTPHeaders.txt
    echoLog "HTTP header discovery of $line done." 3
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "HTTP header discovery completed." 1

}

#Queries the index page of the subdomain and stores it in IndexHTML.txt
#Uses curl
discoverHTMLOfIndex(){
  echoLog "Starting Index HTML discovery..." 2
  while IFS= read -r line; do
    echoLog "Discovering indes HTML of $line ..." 3
    curl $line -m 1 -L -s> $path/reports/$1/$line/IndexHTML.txt
    echoLog "Index HTML discovery of $line done." 3
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Index HTML discovery completed." 1

}

#Filters all urls found in IndexHTML.txt
discoverURLSInIndex(){
  echoLog "Starting Index URL discovery..." 2
  while IFS= read -r line; do
    echoLog "Filtering URL's in index for $line ..." 3
    cat $path/reports/$1/$line/IndexHTML.txt | tr \" \\n | grep https\*:// > $path/reports/$1/$line/urlsInIndex.txt
    cat $path/reports/$1/$line/IndexHTML.txt | tr \" \\n | grep http\*:// >> $path/reports/$1/$line/urlsInIndex.txt
    echoLog "URL filtering of index for $line done." 3
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Index URL discovery completed." 1
}

#Stores html comments found in IndexHTML.txt
#works with multiline comments
#captures multiple comments
discoverHTMLComments(){
  echoLog "Starting comment in index discovery..." 2
  while IFS= read -r line; do
    echoLog "Filtering comments in index for $line ..." 3
    cat $path/reports/$1/$line/IndexHTML.txt |  awk '/<!--/,/-->/'> $path/reports/$1/$line/htmlComments.txt
    echoLog "Comment filtering of index for $line done." 3
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Comments in index discovery completed." 1
}

#Discovers Server HTTP methods using curl with -X OPTIONS,
#Attention!: OPTIONS method can be disabled while some others aren't
discoverServerMethods(){
  echoLog "Starting server HTTP method discovery..." 2
  while IFS= read -r line; do
    echoLog "Discovering HTTP methods of $line ..." 3
    curl $line -X OPTIONS -m 1 -L -s> $path/reports/$1/$line/serverMethods.txt
    echoLog "HTTP method discovery for $line done." 3
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Server HTTP method discovery completed." 1
}
