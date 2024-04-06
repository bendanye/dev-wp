#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

TIMER_FILE="$SCRIPT_DIR/timer"

if test -f "$TIMER_FILE"; then
    clear
    echo "Stop timer"
    START=$(cat $TIMER_FILE)
    rm $TIMER_FILE
    END=$(date +%s)
    secs=$((END-START))
    working_time=$(( secs/60 ))
    resting_time=$(( working_time/5 ))
    rest_until=$(date "-v+$resting_time"M '+%H:%M')

    echo "Total minutes at my desk time: $working_time"
    echo "Please check the communication tools and take a break for $resting_time minutes until $rest_until"
else
    clear
    echo "Start timer"
    START=$(date +%s)
    echo $START > $TIMER_FILE
fi
