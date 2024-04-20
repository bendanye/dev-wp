#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

TASK=$1
if [[ -z $TASK ]]; then
    echo "Please enter the new task to change"
    exit 0
fi

ACTION=$2

if [[ -z $ACTION ]]; then
    ACTION="CHANGE"
fi

TIMER_FILE="$SCRIPT_DIR/../pomodoro_timer/timer"
if [ ! -f "$TIMER_FILE" ]; then
    echo "There is no timer running now"
    exit 0
fi

CURRENT_TASK=$(cat $TIMER_FILE | cut -d ',' -f2)

if [ $ACTION == "CHANGE" ]; then
    sed -i "" "s/$CURRENT_TASK/$TASK/g" $TIMER_FILE
    echo "Updated task from $CURRENT_TASK to $TASK"
fi