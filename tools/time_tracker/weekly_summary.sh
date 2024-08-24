#!/bin/zsh

SCRIPT_DIR=$( dirname -- "$0"; )

source $SCRIPT_DIR/time_tracker_func.sh

while getopts ":a:" opt; do
  case $opt in
    a) ACTION="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

EXCLUDE_PATTERN=$(get_exclude_pattern $ACTION)

# Get the current day of the week (1 for Monday, 2 for Tuesday, ..., 0 for Sunday)
CURRENT_DATE=$(date +%u)

# Calculate the date for the start of the week (Monday)
START_OF_WEEK=$(date -v -$((CURRENT_DATE - 1))d "+%Y-%m-%d")

# Calculate the date for the end of the week (Sunday)
END_OF_WEEK=$(date -v +$((6 - CURRENT_DATE + 1))d "+%Y-%m-%d")

# Loop through the dates from start to end of the week (inclusive)
loop_date=$START_OF_WEEK
while [[ $(date -jf "%Y-%m-%d" "$loop_date" "+%Y%m%d") -le $(date -jf "%Y-%m-%d" "$END_OF_WEEK" "+%Y%m%d") ]]; do
    if test -f "$SCRIPT_DIR/tracking_$loop_date.txt"; then
        file="$SCRIPT_DIR/tracking_$loop_date.txt"
        MINUTES_IN_LOG=$(awk -F, ''"$EXCLUDE_PATTERN"' {if(NR==1)next;total+=$3}END{print total}' $file)
        total_minutes=$(( total_minutes + MINUTES_IN_LOG ))
        total_days=$(( total_days + 1 ))

        HOUR=$(( MINUTES_IN_LOG/60 ))
        MINUTE=$(( MINUTES_IN_LOG-$HOUR*60 ))
        echo "$loop_date (1)  - $HOUR hours, $MINUTE minutes"
    elif test -f "$SCRIPT_DIR/tracking_h_$loop_date.txt"; then
        file="$SCRIPT_DIR/tracking_h_$loop_date.txt"
        MINUTES_IN_LOG=$(awk -F, ''"$EXCLUDE_PATTERN"' {if(NR==1)next;total+=$3}END{print total}' $file)
        total_minutes=$(( total_minutes + MINUTES_IN_LOG ))
        total_days=$(( total_days + .5 ))

        HOUR=$(( MINUTES_IN_LOG/60 ))
        min=$(( MINUTES_IN_LOG-$HOUR*60 ))
        echo "$loop_date (.5) - $HOUR hours, $min minutes"
    elif test -f "$SCRIPT_DIR/tracking_e_$loop_date.txt"; then
        file="$SCRIPT_DIR/tracking_e_$loop_date.txt"
        MINUTES_IN_LOG=$(awk -F, ''"$EXCLUDE_PATTERN"' {if(NR==1)next;total+=$3}END{print total}' $file)
        total_minutes=$(( total_minutes + MINUTES_IN_LOG ))
        HOUR=$(( MINUTES_IN_LOG/60 ))
        min=$(( MINUTES_IN_LOG-$HOUR*60 ))
        echo "$loop_date (E)  - $HOUR hours, $min minutes"
    fi

    # Add one day to the current date
    loop_date=$(date -jf "%Y-%m-%d" -v+1d "$loop_date" "+%Y-%m-%d")
done

if [ -z $total_days ]; then
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

TARGET_HOURS=6
TARGET_MINUTES=50
TARGET_TOTAL_MINUTES=$(( (TARGET_HOURS * 60 + TARGET_MINUTES) * total_days ))

REMAINING_MINUTES=$(( TARGET_TOTAL_MINUTES - total_minutes ))
REMAINING_HOURS=$(( REMAINING_MINUTES / 60 ))
REMAINING_MINUTES=$(( REMAINING_MINUTES % 60 ))

echo "I need to work remaining of $REMAINING_HOURS hours and $REMAINING_MINUTES minutes today to achieve the average target ($TARGET_HOURS hours and $TARGET_MINUTES minutes)"