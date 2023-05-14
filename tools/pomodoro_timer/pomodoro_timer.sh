#!/bin/bash
SCRIPT_DIR=$( dirname -- "$0"; )

FILE="$SCRIPT_DIR/timer"

current_date=$(date '+%Y-%m-%d')
DATA_FILE="$SCRIPT_DIR/working_$current_date.txt"

if ! test -f "$DATA_FILE"; then
    echo "start_date,desk_minutes" > $DATA_FILE
fi

if test -f "$FILE"; then
    echo "Stop timer"
    START=$(cat $FILE)
    rm $FILE
    END=$(date +%s)
    secs=$((END-START))
    working_time=$(( secs/60 ))
    resting_time=$(( working_time/5 ))
    rest_until=$(date "-v+$resting_time"M '+%H:%M')

    echo "Total at my desk time: $working_time minutes"
    echo "Please check your communication tools and take a break until $rest_until"

    START_FORMATTED=$(date -r $START '+%Y-%m-%d %H:%M:%S')
    echo "$START_FORMATTED,$working_time" >> $DATA_FILE
else
    echo "Start timer"
    START=$(date +%s)
    echo $START > $FILE
fi