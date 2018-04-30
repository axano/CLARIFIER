isRoot()
{
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
}

checkArguments(){
if [ $# -eq 0 ]
  then
    echo $0
    exit 1
fi
}
