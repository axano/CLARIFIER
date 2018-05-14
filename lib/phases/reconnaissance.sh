reconRobotsTxt(){
  echoLog "Starting robots.txt recon..."
  while IFS= read -r line; do
    #do $line
    #echo "curl -I $line > $path/reports/$1/$line/nmapResults.txt"
    curl  $line -m 1 -L -s > $path/reports/$1/$line/robots.txt
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "robots.txt recon completed."
}

reconIndexScreenshot(){
  echoLog "Starting screenshot capture..."
  while IFS= read -r line; do
    #do $line
    #echo "curl -I $line > $path/reports/$1/$line/nmapResults.txt"
    #curl  $line -m 1 -L -s > $path/reports/$1/$line/robots.txt
    cutycapt --url=$line --out=$path/reports/$1/$line/$line.png --max-wait=2000 &> /dev/null
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Screenshot capture completed."
}
