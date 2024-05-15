#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

while getopts ":a:t:d:" opt; do
  case $opt in
    a) ACTION="$OPTARG"
    ;;
    t) TASK="$OPTARG"
    ;;
    d) DAY="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ -z $ACTION ]]; then
    ACTION="REPEAT"
fi

if [[ -z $TASK ]]; then
    TASK="MISC"
fi

if [[ -z $DAY ]]; then
    DAY="F"
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
        elif [[ $DAY != "F" ]]; then
            echo "$SCRIPT_DIR/tracking_h_$CURRENT_DATE.txt"
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

data_file=$(get_file)
if ! test -f "$data_file"; then
    echo "start_date,task,desk_minutes" > $data_file
fi

TIMER_FILE="$SCRIPT_DIR/../pomodoro_timer/timer"
while true; do
    data_file=$(get_file)
    if test -f "$TIMER_FILE"; then
        START=$(cat $TIMER_FILE | cut -d ',' -f1)
        CURRENT_TASK=$(cat $TIMER_FILE | cut -d ',' -f2)
        END=$(date +%s)

        sh "$SCRIPT_DIR/../pomodoro_timer/pomodoro_timer.sh"
        
        SECS=$((END-START))
        DESK_TIME=$(( SECS/60 ))
        
        START_FORMATTED=$(date -r $START '+%Y-%m-%d %H:%M:%S')
        echo "$START_FORMATTED,$CURRENT_TASK,$DESK_TIME" >> $data_file

        echo ""
        sh "$SCRIPT_DIR/day_summary.sh"

        if [[ $ACTION == "REPEAT" ]]; then
            echo ""
            python3 $SCRIPT_DIR/focus_task.py d
            echo ""
            if [[ $CURRENT_TASK == "MISC" ]]; then
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
