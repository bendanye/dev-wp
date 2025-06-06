#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/time_tracker_func.sh"

CURRENT_DATE=$(date -v-1d '+%Y-%m-%d')

data_file=$(get_file $CURRENT_DATE)
if ! test -f "$data_file"; then
    echo "There is no tracking file for today"
    exit 1
fi

vi $data_file