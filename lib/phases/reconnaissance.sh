#Tries to retrieve robots.txt and to store it in robots.txt locally
#TODO handle cases where robots.txt is not present on the server
#instead of saving the result of 404.html
reconRobotsTxt(){
  echoLog "Starting robots.txt recon..."
  while IFS= read -r line; do
    curl  $line -m 1 -L -s > $path/reports/$1/$line/robots.txt
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "robots.txt recon completed."
}


#Takes a screenshot from the index page of the subdomain
#and stores it as [subdomain.png]
#Uses cutycapt as it has less dependencies than aquatone or eyewitness
#which use node & npm & nigtmare.js which is indeed a nightmare to install.
reconIndexScreenshot(){
  echoLog "Starting screenshot capture..."
  while IFS= read -r line; do
    cutycapt --url=$line --out=$path/reports/$1/$line/$line.png --max-wait=5000 &> /dev/null
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Screenshot capture completed."
}
