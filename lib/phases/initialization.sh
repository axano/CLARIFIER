#!/bin/bash
initialize(){
  echoLog "Initializing project $1 ..."
  createReportFolder $1
  echoSuccess "Initialization completed."
}


createReportFolder(){

  DIRECTORY="$path/reports/$1"
  echoLog "Checking if $DIRECTORY already exists..."
  if [ -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
    echoError "Directory $DIRECTORY already exists."
    echoError "Exiting..."
    exit 1
  fi

  echoLog "Creating directory with path $DIRECTORY..."
  mkdir $DIRECTORY
  if [ -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
    echoSuccess "DIRECTORY created."
  fi
}
