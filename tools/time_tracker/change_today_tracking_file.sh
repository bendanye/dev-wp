#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

TYPE=$1
if [[ -z $TYPE ]]; then
    echo "Please enter the type (EDIT | HALF)"
    exit 0
fi

CURRENT_DATE=$(date '+%Y-%m-%d')

get_file() {
    local file="$SCRIPT_DIR/tracking_$CURRENT_DATE.txt"
    if test -f "$file"; then
        echo $file
    else
        file="$SCRIPT_DIR/tracking_h_$CURRENT_DATE.txt"
        if test -f "$file"; then
            echo $file
        else
            echo "$SCRIPT_DIR/tracking_$CURRENT_DATE.txt"
        fi
    fi
}

data_file=$(get_file)
if ! test -f "$data_file"; then
    echo "There is no tracking file for today"
    exit 0
fi

if [ $TYPE == "EDIT" ]; then
    vi $data_file
else
    rename_to=$SCRIPT_DIR/tracking_h_$CURRENT_DATE.txt
    echo "Rename from $data_file to $rename_to"
    mv $data_file $rename_to
fi