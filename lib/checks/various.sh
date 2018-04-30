checkIsRoot()
{
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
}

checkArguments(){
  echoLog "Checking arguments..."
if [ $# -eq 0 ]
  then
    echoError "Missing arguments."
    cat $path/manual.txt
    echoError "Exiting..."
    exit 1
fi
echoSuccess "Arguments OK."
}

checkInternetConnection(){
  echoLog "Checking internet connection..."
  wget -q --spider 1.1.1.1
  if [ $? -eq 0 ]; then
      echoSuccess "Connection online."
  else
      echoError "No internet detected."
      echoError "Exiting..."
  fi
}
