#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

IFS="\n"

FILE="$SCRIPT_DIR/timer"
if test -f "$FILE"; then
    while true; do
        START=$(cat $FILE)
        END=$(date +%s)
        DURATION=$((END-START))
        printf "\r Currently at my desk: $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds (press space to exit) "
        read -s -n 1 -t 1 key
        if [ "$key" == " " ]; then
            break
        fi
    done
else
    echo "Timer not started!"
fi 
