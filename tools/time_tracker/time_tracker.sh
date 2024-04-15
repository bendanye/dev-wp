#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

while getopts ":a:t:" opt; do
  case $opt in
    a) action="$OPTARG"
    ;;
    t) task="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ -z $action ]]; then
    action="REPEAT"
fi

if [[ -z $task ]]; then
    task="NIL"
fi

current_date=$(date '+%Y-%m-%d')

get_file() {
    local file="$SCRIPT_DIR/tracking_$current_date.txt"
    if test -f "$file"; then
        echo $file
    else
        file="$SCRIPT_DIR/tracking_h_$current_date.txt"
        if test -f "$file"; then
            echo $file
        else
            echo "$SCRIPT_DIR/tracking_$current_date.txt"
        fi
    fi
}

function start() {
    sh "$SCRIPT_DIR/../pomodoro_timer/pomodoro_timer.sh" $task
    sh "$SCRIPT_DIR/day_summary.sh"
    sh "$SCRIPT_DIR/status.sh"
}

DATA_FILE=$(get_file)
if ! test -f "$DATA_FILE"; then
    echo "start_date,task,desk_minutes" > $DATA_FILE
fi

TIMER_FILE="$SCRIPT_DIR/../pomodoro_timer/timer"
while true; do
    if test -f "$TIMER_FILE"; then
        START=$(cat $TIMER_FILE | cut -d ',' -f1)
        CURRENT_TASK=$(cat $TIMER_FILE | cut -d ',' -f2)
        END=$(date +%s)

        sh "$SCRIPT_DIR/../pomodoro_timer/pomodoro_timer.sh"
        
        secs=$((END-START))
        desk_time=$(( secs/60 ))
        
        START_FORMATTED=$(date -r $START '+%Y-%m-%d %H:%M:%S')
        echo "$START_FORMATTED,$CURRENT_TASK,$desk_time" >> $DATA_FILE

        sh "$SCRIPT_DIR/day_summary.sh"

        if [[ $action == "REPEAT" ]]; then
            if [[ $CURRENT_TASK == "NIL" ]]; then
                read -p "Press return to start timer"
            else
                read -p "Press return to start timer to resume on $CURRENT_TASK"
            fi

            start
        fi
    else
        start
    fi
done
