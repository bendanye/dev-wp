#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/time_tracker_func.sh"
source "$SCRIPT_DIR/time_tracker.env"

# Detect if running on macOS or Linux/Git Bash
IS_MAC=false
if [[ "$OSTYPE" == "darwin"* ]]; then
    IS_MAC=true
fi

date_add_one_day() {
    local base="$1"
    if $IS_MAC; then
        echo $(date -jf "%Y-%m-%d" -v+1d "$base" "+%Y-%m-%d")
    else
        echo $(date -d "$base +1 day" "+%Y-%m-%d")
    fi
}

date_fmt() {
    local date="$1"
    if $IS_MAC; then
        echo $(date -j -f "%Y-%m-%d" "$date" "+%Y%m%d")
    else
        echo $(date -d "$date" "+%Y%m%d")
    fi
}

# Parse arguments
while getopts ":a:" opt; do
  case $opt in
    a) ACTION="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

EXCLUDE_PATTERN=$(get_exclude_pattern $ACTION)

# Get current weekday number (1–7; Monday = 1)
CURRENT_DATE=$(date +%u)

if $IS_MAC; then
    START_OF_WEEK=$(date -v -$((CURRENT_DATE - 1))d "+%Y-%m-%d")
    END_OF_WEEK=$(date -v +$((6 - CURRENT_DATE + 1))d "+%Y-%m-%d")
else
    START_OF_WEEK=$(date -d "$((CURRENT_DATE - 1)) days ago" "+%Y-%m-%d")
    END_OF_WEEK=$(date -d "$((7 - CURRENT_DATE)) days" "+%Y-%m-%d")
fi

loop_date=$START_OF_WEEK
total_minutes=0
total_days=0

while [[ "$(date_fmt "$loop_date")" -le "$(date_fmt "$END_OF_WEEK")" ]]; do
    if [[ -f "$SCRIPT_DIR/tracking_$loop_date.txt" ]]; then
        file="$SCRIPT_DIR/tracking_$loop_date.txt"
        MINUTES_IN_LOG=$(awk -F, ''"$EXCLUDE_PATTERN"' {if(NR==1)next;total+=$3}END{print total}' "$file")
        total_minutes=$(( total_minutes + MINUTES_IN_LOG ))
        total_days=$(( total_days + 1 ))
        HOUR=$(( MINUTES_IN_LOG / 60 ))
        MINUTE=$(( MINUTES_IN_LOG % 60 ))
        echo "$loop_date (1)  - $HOUR hours, $MINUTE minutes"
    elif [[ -f "$SCRIPT_DIR/tracking_h_$loop_date.txt" ]]; then
        file="$SCRIPT_DIR/tracking_h_$loop_date.txt"
        MINUTES_IN_LOG=$(awk -F, ''"$EXCLUDE_PATTERN"' {if(NR==1)next;total+=$3}END{print total}' "$file")
        total_minutes=$(( total_minutes + MINUTES_IN_LOG ))
        total_days=$(( total_days + 1 / 2 ))
        HOUR=$(( MINUTES_IN_LOG / 60 ))
        MINUTE=$(( MINUTES_IN_LOG % 60 ))
        echo "$loop_date (.5) - $HOUR hours, $MINUTE minutes"
    elif [[ -f "$SCRIPT_DIR/tracking_e_$loop_date.txt" ]]; then
        file="$SCRIPT_DIR/tracking_e_$loop_date.txt"
        MINUTES_IN_LOG=$(awk -F, ''"$EXCLUDE_PATTERN"' {if(NR==1)next;total+=$3}END{print total}' "$file")
        total_minutes=$(( total_minutes + MINUTES_IN_LOG ))
        HOUR=$(( MINUTES_IN_LOG / 60 ))
        MINUTE=$(( MINUTES_IN_LOG % 60 ))
        echo "$loop_date (E)  - $HOUR hours, $MINUTE minutes"
    fi

    loop_date=$(date_add_one_day "$loop_date" +1)
done

if [[ -z "$total_days" || "$total_days" == "0" ]]; then
    echo "There is no tracking information from $START_OF_WEEK to $END_OF_WEEK"
    exit 0
fi

if (( total_days > 1 )); then
average_minutes=$(( total_minutes / total_days ))
else
    average_minutes=$total_minutes
fi

# Remove decimal place
average_minutes=${average_minutes%.*}

AVERAGE_HOUR=$(( average_minutes/60 ))
AVERAGE_MIN=$(( average_minutes-$AVERAGE_HOUR*60 ))

if [[ $EXCLUDE_PATTERN == "" ]]; then
    EXCLUDE_MSG=""
else
    EXCLUDE_MSG="after excluding tasks"
fi

echo "On average ($total_days days), I am on my desk for $AVERAGE_HOUR hours, $AVERAGE_MIN minutes $EXCLUDE_MSG"
echo ""

TARGET_TOTAL_MINUTES=$(( (TARGET_HOURS * 60 + TARGET_MINUTES) * total_days ))

remaining_minutes=$(( TARGET_TOTAL_MINUTES - total_minutes ))

# Remove decimal place
remaining_minutes=${remaining_minutes%.*}

AVERAGE_REMAINING_HOURS=$(( remaining_minutes / 60 ))
AVERAGE_REMAINING_MINUTES=$(( remaining_minutes % 60 ))

if [[ $AVERAGE_REMAINING_HOURS -le 0 ]] && [[ $AVERAGE_REMAINING_MINUTES -le 0 ]]; then
    echo "I have meet the average target of $TARGET_HOURS hours and $TARGET_MINUTES minutes over $total_days days!"
else
    echo "I need to work the remaining of $AVERAGE_REMAINING_HOURS hours and $AVERAGE_REMAINING_MINUTES minutes today to meet the average target of $TARGET_HOURS hours and $TARGET_MINUTES minutes over $total_days days."
fi
