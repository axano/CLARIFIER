#!/bin/bash

myExit(){
  echoError "Exiting..."
  exit 1
}

echoTotalTimeTaken(){
  seconds=$((end-start))
  parsedSecondsToTimeformat=$(convertSecondsToDaysHoursMinutesSeconds $seconds .)
echoLog "Time taken to complete main test: $parsedSecondsToTimeformat "
}

convertSecondsToDaysHoursMinutesSeconds() {
    num=$1
    min=0
    hour=0
    day=0
    if((num>59));then
        ((sec=num%60))
        ((num=num/60))
        if((num>59));then
            ((min=num%60))
            ((num=num/60))
            if((num>23));then
                ((hour=num%24))
                ((day=num/24))
            else
                ((hour=num))
            fi
        else
            ((min=num))
        fi
    else
        ((sec=num))
    fi
    echo "$day" Days "$hour" Hours "$min" Minutes and "$sec" Seconds
}
