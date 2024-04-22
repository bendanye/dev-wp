#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

TIMER_FILE="$SCRIPT_DIR/../pomodoro_timer/timer"
if test -f "$TIMER_FILE"; then
    while true; do
        START=$(cat $TIMER_FILE | cut -d ',' -f1)
        TASK=$(cat $TIMER_FILE | cut -d ',' -f2)
        END=$(date +%s)
        DURATION=$((END-START))

        if [[ $TASK == "MISC" ]]; then
            printf "\r Currently at my desk for $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds (press space to exit) "
        else
            printf "\r Currently at my desk focusing on $TASK for $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds (press space to exit) "
        fi
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
