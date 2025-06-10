#!/bin/bash
BKUP_FOLDER="bkup"

SCRIPT_DIR=$( dirname -- "$0"; )

cd "$SCRIPT_DIR"

if [ ! -d $BKUP_FOLDER ]; then
    mkdir $BKUP_FOLDER
fi

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

# Get the current day of the week (1 for Monday, 2 for Tuesday, ..., 0 for Sunday)
CURRENT_DATE=$(date +%u)

if $IS_MAC; then
    START_OF_WEEK=$(date -v -$((CURRENT_DATE - 1))d "+%Y-%m-%d")
    END_OF_WEEK=$(date -v +$((6 - CURRENT_DATE + 1))d "+%Y-%m-%d")
else
    START_OF_WEEK=$(date -d "$((CURRENT_DATE - 1)) days ago" "+%Y-%m-%d")
    END_OF_WEEK=$(date -d "$((7 - CURRENT_DATE)) days" "+%Y-%m-%d")
fi

# Loop through the dates from start to end of the week (inclusive)
current_date=$START_OF_WEEK
while [[ "$(date_fmt "$current_date")" -le "$(date_fmt "$END_OF_WEEK")" ]]; do
    file="$SCRIPT_DIR/tracking_$current_date.txt"
    if ! test -f "$file"; then
        file="$SCRIPT_DIR/tracking_h_$current_date.txt"
        if test -f "$file"; then
            echo "Already have this week file. Do not need to backup"
            exit 0
        fi
    else
        echo "Already have this week file. Do not need to backup"
        exit 0
    fi

    # Add one day to the current date
    current_date=$(date_add_one_day "$current_date")
done

mv tracking_*.txt $BKUP_FOLDER