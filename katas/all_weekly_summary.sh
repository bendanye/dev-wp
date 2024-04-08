#!/usr/bin/env bash

cd "$(dirname "$0")"

source source.env

function check() {
    local dir=$1
    # Get the current day of the week (1 for Monday, 2 for Tuesday, ..., 0 for Sunday)
    current_day=$(date +%u)

    # Calculate the date for the start of the week (Monday)
    start_of_week=$(date -v -$((current_day - 1))d "+%Y-%m-%d")

    # Calculate the date for the end of the week (Sunday)
    end_of_week=$(date -v +$((6 - current_day + 1))d "+%Y-%m-%d")

    current_date=$start_of_week

    has_result="false"

    # Loop through the dates from start to end of the week (inclusive)
    while [[ $(date -jf "%Y-%m-%d" "$current_date" "+%Y%m%d") -le $(date -jf "%Y-%m-%d" "$end_of_week" "+%Y%m%d") ]]; do

        if [[ ! -f "$dir/$TIME_TAKEN_FILE_NAME" ]]; then
            echo -e "[ ] $dir"
        else
            result=$(cat $dir/$TIME_TAKEN_FILE_NAME | grep $current_date)
            if [[ $result ]]; then
                secs=${result##*,}
                echo -e "[\xE2\x9C\x94] $dir - $current_date"
                has_result="true"
                break
            fi
        fi
        
        # Add one day to the current date
        current_date=$(date -jf "%Y-%m-%d" -v+1d "$current_date" "+%Y-%m-%d")
    done

    if [[ $has_result == "false" ]]; then
        echo -e "[ ] $dir"
    fi
 }

katas=$(jq -c '.katas[]' $SCHEDULE_FILE_NAME)
for kata in $katas; do
    name=$(jq -r '.name' <<< "$kata")
    kata_directory=$(jq -r '.repo_dir' <<< "$kata")
    multiple_kata=$(jq -r '.["contains-multiple-kata"]' <<< "$kata")
    if [[ $multiple_kata == "true" ]]; then
        for dir in $kata_directory/*/ ; do
            check $dir
        done
    else
        check $kata_directory
    fi
done

