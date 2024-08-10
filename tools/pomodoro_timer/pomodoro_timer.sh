#!/bin/bash

TASK=$1
if [[ -z $TASK ]]; then
    TASK="MISC"
fi

SCRIPT_DIR=$( dirname -- "$0"; )

TIMER_FILE="$SCRIPT_DIR/timer"

if test -f "$TIMER_FILE"; then
    clear
    START=$(cat $TIMER_FILE | cut -d ',' -f1)
    TASK=$(cat $TIMER_FILE | cut -d ',' -f2)
    rm $TIMER_FILE
    END=$(date +%s)

    END_TIME=$(date +"%H:%M")
    echo "Stop timer at $END_TIME"
    
    SECS=$((END-START))
    DESK_TIME=$(( SECS/60 ))
    RESTING_TIME=$(( DESK_TIME/5 ))
    REST_UNTIL=$(date "-v+$RESTING_TIME"M '+%H:%M')

    if [[ $TASK == "MISC" ]]; then
        echo "Total minutes at my desk time: $DESK_TIME"
    else
        echo "Total minutes at my desk time focusing on $TASK: $DESK_TIME"
    fi

    if [[ $RESTING_TIME == 0 ]]; then
        echo "Please check the communication tools and take a short break if required"
    else
        echo "Please check the communication tools and take a break for $RESTING_TIME minutes until $REST_UNTIL"
    fi
else
    clear
    echo "Start timer"
    START=$(date +%s)
    echo "${START},${TASK}" > $TIMER_FILE
fi
