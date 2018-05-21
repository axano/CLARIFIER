#!/bin/bash
SCRIPT=`realpath -s $0`
path=`dirname $SCRIPT`

#####IMPORTS
#Priority matters and imports have to come after path and SCRIPT variables
source $path/lib/interface/decoration.sh
source $path/lib/uncategorized/housekeeping.sh
source $path/lib/checks/prerequisites.sh
source $path/lib/checks/internet.sh
source $path/lib/checks/system.sh
source $path/lib/checks/arguments.sh
source $path/lib/phases/initialization.sh
source $path/lib/phases/footprinting.sh
source $path/lib/phases/advancedFootprinting.sh
source $path/lib/phases/reconnaissance.sh



checkIsValidIp $1
echo $?
end=`date +%s`
echoTotalTimeTaken
