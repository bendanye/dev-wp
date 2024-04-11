#!/bin/bash

TASK=$1
if [[ -z $TASK ]]; then
    TASK="NIL"
fi

SCRIPT_DIR=$( dirname -- "$0"; )

TIMER_FILE="$SCRIPT_DIR/timer"

if test -f "$TIMER_FILE"; then
    clear
    echo "Stop timer"
    START=$(cat $TIMER_FILE | cut -d ',' -f1)
    TASK=$(cat $TIMER_FILE | cut -d ',' -f2)
    rm $TIMER_FILE
    END=$(date +%s)
    secs=$((END-START))
    working_time=$(( secs/60 ))
    resting_time=$(( working_time/5 ))
    rest_until=$(date "-v+$resting_time"M '+%H:%M')

    if [[ $TASK == "NIL" ]]; then
        echo "Total minutes at my desk time: $working_time"
    else
        echo "Total minutes at my desk time working on $TASK: $working_time"
    fi
    echo "Please check the communication tools and take a break for $resting_time minutes until $rest_until"
else
    clear
    echo "Start timer"
    START=$(date +%s)
    echo "${START},${TASK}" > $TIMER_FILE
fi
