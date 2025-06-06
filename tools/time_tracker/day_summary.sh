#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/time_tracker_func.sh"

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

EXCLUDE_PATTERN=$(get_exclude_pattern $ACTION)

FILE=$(get_file $CURRENT_DATE)
if ! test -f "$FILE"; then
    echo "There is no tracking information for $CURRENT_DATE"
    exit 1
fi

TOTAL_MINUTES=$(awk -F, ''"$EXCLUDE_PATTERN"' {if(NR==1)next;total+=$3}END{print total}' "$FILE")

HOUR=$(( TOTAL_MINUTES/60 ))
MINUTE=$(( TOTAL_MINUTES-$HOUR*60 ))

if [[ $EXCLUDE_PATTERN == "" ]]; then
    EXCLUDE_MSG=""
else
    EXCLUDE_MSG="after excluding tasks"
fi

if [[ $SPECIFIED_DATE ]]; then
    echo "On ($CURRENT_DATE), I am at my desk for $HOUR hours, $MINUTE minutes $EXCLUDE_MSG" 
else
    echo "Today ($CURRENT_DATE), I am at my desk for $HOUR hours, $MINUTE minutes $EXCLUDE_MSG" 
fi
