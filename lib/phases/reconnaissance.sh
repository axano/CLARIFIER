#Tries to retrieve robots.txt and to store it in robots.txt locally
#TODO handle cases where robots.txt is not present on the server
#instead of saving the result of 404.html
reconRobotsTxt(){
  echoLog "Starting robots.txt recon..." 1
  while IFS= read -r line; do
    echoLog "Reconing robots.txt of $line ..." 3
    curl  $line/robots.txt -m 1 -L -s > $path/reports/$1/$line/robots.txt
    echoLog "Recon of robots.txt for $line done." 3
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "robots.txt recon completed." 1
}

reconHumansTxt(){
  echoLog "Starting humans.txt recon..." 1
  while IFS= read -r line; do
    echoLog "Reconing humans.txt of $line ..." 3
    curl  $line/humants.txt -m 1 -L -s > $path/reports/$1/$line/humans.txt
    echoLog "Recon humans.txt of $line done." 3
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "humans.txt recon completed." 1
}

#Takes a screenshot from the index page of the subdomain
#and stores it as [subdomain.png]
#Uses cutycapt as it has less dependencies than aquatone or eyewitness
#which use node & npm & nigtmare.js which is indeed a nightmare to install.
reconIndexScreenshot(){
  echoLog "Starting screenshot capture..." 1
  while IFS= read -r line; do
    echoLog "Capturing screenshot of $line ..." 3
    cutycapt --url=$line --out=$path/reports/$1/$line/$line.png --max-wait=5000 &> /dev/null
    echoLog "Screenshot capture of $line done." 3
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Screenshot capture completed." 1
}
