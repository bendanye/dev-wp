#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

source $SCRIPT_DIR/time_tracker_func.sh
source $SCRIPT_DIR/../source.env

yesterday=$(date -v -1d +%u)

if [ "$yesterday" -lt 1 ] && [ "$yesterday" -ge 5 ]; then
    echo "Yesterday was not mon-thurs. Exit"
    exit 0
fi

echo "Yesterday was mon-thurs. Proceed to check"
    
YESTERDAY_DATE=$(date -v -1d +%Y-%m-%d)

data_file=$(get_file $YESTERDAY_DATE)
if test -f "$data_file"; then
    echo "Found $YESTERDAY_DATE file. No actions needed"
else
    MESSAGE="Missing $YESTERDAY_DATE file. Could be not working or PH. Please proceed to do neccessary action if needed"
    if [[ $ALERTME_MAIN_FILE != "" ]]; then
        sh $ALERTME_MAIN_FILE -m $MESSAGE
    else
        echo $MESSAGE
    fi
fi