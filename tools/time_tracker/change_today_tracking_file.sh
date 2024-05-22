#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

source $SCRIPT_DIR/time_tracker_func.sh

TYPE=$1
if [[ -z $TYPE ]]; then
    echo "Please enter the type (EDIT | HALF)"
    exit 0
fi

CURRENT_DATE=$(date '+%Y-%m-%d')

data_file=$(get_file $CURRENT_DATE)
if ! test -f "$data_file"; then
    echo "There is no tracking file for today"
    exit 1
fi

if [ $TYPE == "EDIT" ]; then
    vi $data_file
else
    rename_to=$SCRIPT_DIR/tracking_h_$CURRENT_DATE.txt
    echo "Rename from $data_file to $rename_to"
    mv $data_file $rename_to
fi