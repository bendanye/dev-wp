#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

while getopts ":a:t:" opt; do
  case $opt in
    a) ACTION="$OPTARG"
    ;;
    t) TASK="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ -z $ACTION ]]; then
    ACTION="REPEAT"
fi

if [[ -z $TASK ]]; then
    TASK="NIL"
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

function start() {
    local task=$1
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
        
        SECS=$((END-START))
        DESK_TIME=$(( SECS/60 ))
        
        START_FORMATTED=$(date -r $START '+%Y-%m-%d %H:%M:%S')
        echo "$START_FORMATTED,$CURRENT_TASK,$DESK_TIME" >> $DATA_FILE

        sh "$SCRIPT_DIR/day_summary.sh"

        if [[ $ACTION == "REPEAT" ]]; then
            if [[ $CURRENT_TASK == "NIL" ]]; then
                read -p "Press return to start timer or type a new task before press: " NEW_TASK
            else
                read -p "Press return to start timer to resume on $CURRENT_TASK or type a new task before press: " NEW_TASK
            fi

            if [[ -z $NEW_TASK ]]; then
                start $CURRENT_TASK
            else
                start $NEW_TASK
            fi
        fi
    else
        start $TASK
    fi
done
