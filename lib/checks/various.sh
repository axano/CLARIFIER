checkIsRoot()
{
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
}

checkAndParseArguments(){
  echoLog "Checking arguments..."
  while getopts ":hd:" opt; do
  case $opt in
    d)
      echoSuccess "-d was triggered!" >&2
      result=$(checkIsValidDomain $OPTARG)
      if [[ $result -eq 1 ]]; then
          domainToTest=$OPTARG
      else
        echoError "Invalid domain or domain cannot be reached."
        echoError "Exiting..."
        exit 1
      fi


      ;;
    h)
      echoSuccess "-h was triggered!" >&2
      cat manual.txt
      echoError "Exiting..."
      exit 1
      ;;
    :)
      echoError "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    \?)
      echoError "Invalid option: -$OPTARG" >&2
      echoError "Exiting..."
      exit 1
      ;;
  esac
done
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

checkIsValidDomain(){
  host $1 2>&1 > /dev/null
    if [ $? -eq 0 ]
    then
        return 1
    else
        return 0
    fi
}
