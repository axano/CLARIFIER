#!/bin/bash
initialize(){
  echoLog "Initializing project $1 ..."

  createReportFolder $1
  echoSuccess "Initialization completed."
}

initializeFolderForEverySubdomain(){
  echoLog "Initializing subdomain folder structure..."
  DIRECTORY="$path/reports/$1"
  while IFS= read -r line; do
    #do $line
    mkdir "$DIRECTORY/$line"
  done < "$path/reports/$1/subdomains.txt"
  echoLog "Initialization completed."
}

createReportFolder(){

  DIRECTORY="$path/reports/$1"
  echoLog "Checking if $DIRECTORY already exists..."
  if [ -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
    echoError "Directory $DIRECTORY already exists."
    myExit
  fi

  echoLog "Creating directory with path $DIRECTORY..."
  mkdir $DIRECTORY
  if [ -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
    echoSuccess "Directory created."
  fi
}
