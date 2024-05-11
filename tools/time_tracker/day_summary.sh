#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

while getopts ":a:d:" opt; do
  case $opt in
    a) ACTION="$OPTARG"
    ;;
    d) SPECIFIED_DATE="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ $SPECIFIED_DATE ]]; then
    CURRENT_DATE=$SPECIFIED_DATE
else
    CURRENT_DATE=$(date '+%Y-%m-%d')
fi

if [[ $ACTION == "EXCLUDE_TASKS" ]]; then
    EXCLUDE_PATTERN="!/(MISC|kata|feedback|conf_talk)/"
else
    EXCLUDE_PATTERN=""
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

TOTAL_MINUTES=$(awk -F, ''"$EXCLUDE_PATTERN"' {if(NR==1)next;total+=$3}END{print total}' $FILE)

HOUR=$(( TOTAL_MINUTES/60 ))
MINUTE=$(( TOTAL_MINUTES-$HOUR*60 ))

if [[ $1 ]]; then
    echo "On ($CURRENT_DATE), I am at my desk for $HOUR hours, $MINUTE minutes" 
else
    echo "Today ($CURRENT_DATE), I am at my desk for $HOUR hours, $MINUTE minutes" 
fi
