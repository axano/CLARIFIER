#!/bin/bash

#this function executes and encapsulates $1
#so that it can see if it is still running
#https://stackoverflow.com/questions/20165057/executing-bash-loop-while-command-is-running
executeAndMonitorStatus(){
  echoDebug "Executing and monitoring $1" 3
  eval $1 &
  pid=$!

  # If this script is killed, kill the `$1' command.
  trap "kill $pid 2> /dev/null" EXIT

  # While command is command is running...
  # spinner
  spin='-\|/'
  i=0
  while kill -0 $pid 2> /dev/null; do
      i=$(( (i+1) %4 ))
      echoSpinner "Running ${spin:$i:1}"
      sleep 0.1
  done
  echo ''
  # Disable the trap on a normal exit.
  trap - EXIT

}
