#!/bin/zsh

SCRIPT_DIR=$( dirname -- "$0"; )

while getopts ":a:" opt; do
  case $opt in
    a) ACTION="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ $ACTION == "EXCLUDE_TASKS" ]]; then
    EXCLUDE_PATTERN="!/(MISC|kata|feedback|conf_talk)/"
else
    EXCLUDE_PATTERN=""
fi

# Get the current day of the week (1 for Monday, 2 for Tuesday, ..., 0 for Sunday)
CURRENT_DATE=$(date +%u)

# Calculate the date for the start of the week (Monday)
START_OF_WEEK=$(date -v -$((CURRENT_DATE - 1))d "+%Y-%m-%d")

# Calculate the date for the end of the week (Sunday)
END_OF_WEEK=$(date -v +$((6 - CURRENT_DATE + 1))d "+%Y-%m-%d")

# Loop through the dates from start to end of the week (inclusive)
loop_date=$START_OF_WEEK
while [[ $(date -jf "%Y-%m-%d" "$loop_date" "+%Y%m%d") -le $(date -jf "%Y-%m-%d" "$END_OF_WEEK" "+%Y%m%d") ]]; do
    file="$SCRIPT_DIR/tracking_$loop_date.txt"
    if test -f "$file"; then
        MINUTES_IN_LOG=$(awk -F, ''"$EXCLUDE_PATTERN"' {if(NR==1)next;total+=$3}END{print total}' $file)
        total_minutes=$(( total_minutes + MINUTES_IN_LOG ))
        total_days=$(( total_days + 1 ))

        HOUR=$(( MINUTES_IN_LOG/60 ))
        MINUTE=$(( MINUTES_IN_LOG-$HOUR*60 ))
        echo "$loop_date (1)  - $HOUR hours, $MINUTE minutes"
    else
        file="$SCRIPT_DIR/tracking_h_$loop_date.txt"
        if test -f "$file"; then
            MINUTES_IN_LOG=$(awk -F, ''"$EXCLUDE_PATTERN"' {if(NR==1)next;total+=$3}END{print total}' $file)
            total_minutes=$(( total_minutes + MINUTES_IN_LOG ))
            total_days=$(( total_days + .5 ))

            HOUR=$(( MINUTES_IN_LOG/60 ))
            min=$(( MINUTES_IN_LOG-$HOUR*60 ))
            echo "$loop_date (.5) - $HOUR hours, $min minutes"
        fi
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

echo "On average ($total_days days), I am on my desk for $AVERAGE_HOUR hours, $AVERAGE_MIN minutes" 
