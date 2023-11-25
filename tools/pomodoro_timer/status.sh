#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

FILE="$SCRIPT_DIR/timer"
if test -f "$FILE"; then
    while true; do
        START=$(cat $FILE)
        END=$(date +%s)
        DURATION=$((END-START))
        printf "\r Currently at my desk: $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds"
        sleep 1
    done
else
    echo "Timer not started!"
fi 
