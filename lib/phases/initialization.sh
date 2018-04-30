#!/bin/bash
initialize(){
createReportFolder $1

}


createReportFolder(){

  DIRECTORY="$path/reports/$1"

  if [ -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
    echoError "Directory $DIRECTORY already exists."
    echoError "Exiting..."
  fi

}
