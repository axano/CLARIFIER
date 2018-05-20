#!/bin/bash
initialize(){
  echoLog "Initializing project $1 ..." 2

  createReportFolder $1
  echoSuccess "Initialization completed." 1
}

initializeFolderForEverySubdomain(){
  echoLog "Initializing subdomain folder structure..." 2
  DIRECTORY="$path/reports/$1"
  while IFS= read -r line; do
    #do $line
    mkdir "$DIRECTORY/$line"
  done < "$path/reports/$1/subdomains.txt"
  echoSuccess "Initialization completed." 1
}

createReportFolder(){

  DIRECTORY="$path/reports/$1"
  echoLog "Checking if $DIRECTORY already exists..." 2
  if [ -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
    echoError "Directory $DIRECTORY already exists." 0
    myExit
  fi

  echoLog "Creating directory with path $DIRECTORY..." 3
  mkdir $DIRECTORY
  if [ -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
    echoSuccess "Directory created." 1
  fi
}
