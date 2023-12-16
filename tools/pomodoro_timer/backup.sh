#!/bin/bash
BKUP_FOLDER="bkup"

SCRIPT_DIR=$( dirname -- "$0"; )

cd $SCRIPT_DIR

if [ ! -d $BKUP_FOLDER ]; then
    mkdir $BKUP_FOLDER
fi

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
    if ! test -f "$file"; then
        file="$SCRIPT_DIR/working_h_$current_date.txt"
        if test -f "$file"; then
            echo "Already have this week file. Do not need to backup"
            exit 0
        fi
    else
        echo "Already have this week file. Do not need to backup"
        exit 0
    fi

    # Add one day to the current date
    current_date=$(date -jf "%Y-%m-%d" -v+1d "$current_date" "+%Y-%m-%d")
done

mv working_*.txt $BKUP_FOLDER