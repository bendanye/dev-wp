#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [[ -z $1 ]]; then
    ACTION="REPEAT"
else
    ACTION=$1
fi

current_date=$(date '+%Y-%m-%d')

get_file() {
    local file="$SCRIPT_DIR/working_$current_date.txt"
    if test -f "$file"; then
        echo $file
    else
        file="$SCRIPT_DIR/working_h_$current_date.txt"
        if test -f "$file"; then
            echo $file
        else
            echo "$SCRIPT_DIR/working_$current_date.txt"
        fi
    fi
}

function start() {
    sh "$SCRIPT_DIR/../pomodoro_timer/pomodoro_timer.sh"
    sh "$SCRIPT_DIR/day_summary.sh"
    sh "$SCRIPT_DIR/status.sh"
}

DATA_FILE=$(get_file)
if ! test -f "$DATA_FILE"; then
    echo "start_date,desk_minutes" > $DATA_FILE
fi

TIMER_FILE="$SCRIPT_DIR/../pomodoro_timer/timer"
while true; do
    if test -f "$TIMER_FILE"; then
        START=$(cat $TIMER_FILE)
        END=$(date +%s)

        sh "$SCRIPT_DIR/../pomodoro_timer/pomodoro_timer.sh"
        
        secs=$((END-START))
        working_time=$(( secs/60 ))
        
        START_FORMATTED=$(date -r $START '+%Y-%m-%d %H:%M:%S')
        echo "$START_FORMATTED,$working_time" >> $DATA_FILE

        sh "$SCRIPT_DIR/day_summary.sh"

        if [[ $ACTION == "REPEAT" ]]; then
            read -p "Press return to start timer"

            start
        fi
    else
        start
    fi
done