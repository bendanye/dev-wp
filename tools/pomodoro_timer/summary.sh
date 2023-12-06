#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [[ $1 ]]; then
    current_date=$1
else
    current_date=$(date '+%Y-%m-%d')
fi

FILE="$SCRIPT_DIR/working_$current_date.txt"

if ! test -f "$FILE"; then
    echo "$current_date does not exist!"
    exit 1
fi

total_minutes=$(awk -F, '{if(NR==1)next;total+=$2}END{print total}' $FILE)

hour=$(( total_minutes/60 ))
min=$(( total_minutes-$hour*60 ))

if [[ $1 ]]; then
    echo "On ($current_date), I am on my desk for $hour hours, $min minutes" 
else
    echo "Today ($current_date), I am on my desk for $hour hours, $min minutes" 
fi