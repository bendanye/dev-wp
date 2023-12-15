#!/bin/zsh

SCRIPT_DIR=$( dirname -- "$0"; )

# Get the current day of the week (1 for Monday, 2 for Tuesday, ..., 0 for Sunday)
current_day=$(date +%u)

# Calculate the date for the start of the week (Monday)
start_of_week=$(date -v -$((current_day - 1))d "+%Y-%m-%d")

# Calculate the date for the end of the week (Sunday)
end_of_week=$(date -v +$((6 - current_day + 1))d "+%Y-%m-%d")

# Loop through the dates from start to end of the week (inclusive)
current_date=$start_of_week
while [[ $(date -jf "%Y-%m-%d" "$current_date" "+%Y%m%d") -le $(date -jf "%Y-%m-%d" "$end_of_week" "+%Y%m%d") ]]; do
    file="$SCRIPT_DIR/working_$current_date.txt"
    if test -f "$file"; then
        minutes=$(awk -F, '{if(NR==1)next;total+=$2}END{print total}' $file)
        total_minutes=$(( total_minutes + minutes ))
        total_working_days=$(( total_working_days + 1 ))
    else
        file="$SCRIPT_DIR/working_h_$current_date.txt"
        if test -f "$file"; then
            minutes=$(awk -F, '{if(NR==1)next;total+=$2}END{print total}' $file)
            total_minutes=$(( total_minutes + minutes ))
            total_working_days=$(( total_working_days + .5 ))
        fi
    fi

    # Add one day to the current date
    current_date=$(date -jf "%Y-%m-%d" -v+1d "$current_date" "+%Y-%m-%d")
done

if [ -z $total_working_days ]; then
    echo "There is no working information for this week"
    exit 0
fi

if (( total_working_days > 1 )); then
   average_working_minutes=$(( total_minutes / total_working_days ))
else
    average_working_minutes=$total_minutes
fi

# Remove decimal place
average_working_minutes=${average_working_minutes%.*}

average_hour=$(( average_working_minutes/60 ))
average_min=$(( average_working_minutes-$average_hour*60 ))

echo "On average ($total_working_days days), I am on my desk for $average_hour hours, $average_min minutes" 
