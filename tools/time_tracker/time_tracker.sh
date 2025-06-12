#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/time_tracker_func.sh"

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

function start() {
    local task=$1
    python3 "$SCRIPT_DIR/../pomodoro_timer/pomodoro_timer.py" "$task"
    sh "$SCRIPT_DIR/day_summary.sh" -a "EXCLUDE_TASKS"
    python3 "$SCRIPT_DIR/status.py"
}

data_file=$(get_file $CURRENT_DATE)
if ! test -f "$data_file"; then
    if [[ $DAY != "F" ]]; then
        data_file="$SCRIPT_DIR/tracking_h_$CURRENT_DATE.txt"
    else
        data_file="$SCRIPT_DIR/tracking_$CURRENT_DATE.txt"
    fi
    echo "start_date,task,desk_minutes" > "$data_file"
fi

TIMER_FILE="$SCRIPT_DIR/../pomodoro_timer/timer"
while true; do
    data_file=$(get_file $CURRENT_DATE)
    if test -f "$TIMER_FILE"; then
        START=$(cat "$TIMER_FILE" | cut -d ',' -f1)
        CURRENT_TASK=$(cat "$TIMER_FILE" | cut -d ',' -f2)
        END=$(date +%s)

        python3 "$SCRIPT_DIR/../pomodoro_timer/pomodoro_timer.py" $task
        
        SECS=$((END-START))
        DESK_TIME=$(( SECS/60 ))
        
        if [[ $OSTYPE == "darwin"* ]]; then
            START_FORMATTED=$(date -r $START '+%Y-%m-%d %H:%M:%S')
        elif [[ $OSTYPE == "msys" || $OSTYPE == "cygwin"* ]]; then
            START_FORMATTED=$(date -d @"$START" '+%Y-%m-%d %H:%M:%S')
        fi
        
        echo "$START_FORMATTED,$CURRENT_TASK,$DESK_TIME" >> "$data_file"
        echo ""
        sh "$SCRIPT_DIR/day_summary.sh"  -a "EXCLUDE_TASKS"

        if [[ $ACTION == "REPEAT" ]]; then
            echo ""
            echo "Recent focus tasks"
            echo "--"
            python3 "$SCRIPT_DIR/display_all_tasks.py" NO_HEADER
            echo "--"
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
