#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

TIMER_FILE="$SCRIPT_DIR/../pomodoro_timer/timer"
if test -f "$TIMER_FILE"; then
    while true; do
        START=$(cat $TIMER_FILE)
        END=$(date +%s)
        DURATION=$((END-START))
        printf "\r Currently at my desk: $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds (press space to exit) "
        IFS="\n"
        read -s -n 1 -t 1 key
        if [ "$key" == " " ]; then
            break
        fi
        IFS=""
    done
else
    echo "Timer not started!"
fi 
