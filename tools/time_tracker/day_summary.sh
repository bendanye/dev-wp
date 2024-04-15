#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [[ $1 ]]; then
    CURRENT_DATE=$1
else
    CURRENT_DATE=$(date '+%Y-%m-%d')
fi

get_file() {
    local file="$SCRIPT_DIR/tracking_$CURRENT_DATE.txt"
    if test -f "$file"; then
        echo $file
    else
        file="$SCRIPT_DIR/tracking_h_$CURRENT_DATE.txt"
        if test -f "$file"; then
            echo $file
        else
            echo "$CURRENT_DATE does not exist!"
            exit 1
        fi
    fi
}

FILE=$(get_file)
if ! test -f "$FILE"; then
    echo "There is no tracking information for $CURRENT_DATE"
    exit 0
fi

TOTAL_MINUTES=$(awk -F, '{if(NR==1)next;total+=$3}END{print total}' $FILE)

HOUR=$(( TOTAL_MINUTES/60 ))
MINUTE=$(( TOTAL_MINUTES-$HOUR*60 ))

if [[ $1 ]]; then
    echo "On ($CURRENT_DATE), I am at my desk for $HOUR hours, $MINUTE minutes" 
else
    echo "Today ($CURRENT_DATE), I am at my desk for $HOUR hours, $MINUTE minutes" 
fi
