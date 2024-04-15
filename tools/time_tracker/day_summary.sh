#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [[ $1 ]]; then
    current_date=$1
else
    current_date=$(date '+%Y-%m-%d')
fi

get_file() {
    local file="$SCRIPT_DIR/tracking_$current_date.txt"
    if test -f "$file"; then
        echo $file
    else
        file="$SCRIPT_DIR/tracking_h_$current_date.txt"
        if test -f "$file"; then
            echo $file
        else
            echo "$current_date does not exist!"
            exit 1
        fi
    fi
}

FILE=$(get_file)
if ! test -f "$FILE"; then
    echo "There is no tracking information for $current_date"
    exit 0
fi

total_minutes=$(awk -F, '{if(NR==1)next;total+=$3}END{print total}' $FILE)

hour=$(( total_minutes/60 ))
min=$(( total_minutes-$hour*60 ))

if [[ $1 ]]; then
    echo "On ($current_date), I am at my desk for $hour hours, $min minutes" 
else
    echo "Today ($current_date), I am at my desk for $hour hours, $min minutes" 
fi
