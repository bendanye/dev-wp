#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

TYPE=$1
if [[ -z $TYPE ]]; then
    echo "Please enter the type (CURRENT | ALL)"
    exit 0
fi

change_current_task() {
    NEW_TASK=$1
    if [[ -z $NEW_TASK ]]; then
        echo "Please enter the new task to change"
        exit 0
    fi

    TIMER_FILE="$SCRIPT_DIR/../pomodoro_timer/timer"
    if [ ! -f "$TIMER_FILE" ]; then
        echo "There is no timer running now"
        exit 0
    fi
    CURRENT_TASK=$(cat $TIMER_FILE | cut -d ',' -f2)
    sed -i "" "s/$CURRENT_TASK/$TASK/g" $TIMER_FILE
    echo "Updated current task, $CURRENT_TASK to $NEW_TASK"
}

change_all_matching_task() {
    OLD_TASK=$1
    if [[ -z $OLD_TASK ]]; then
        echo "Please enter the old task to change"
        exit 0
    fi

    NEW_TASK=$2
    if [[ -z $NEW_TASK ]]; then
        echo "Please enter the new task to change"
        exit 0
    fi

    find "$SCRIPT_DIR" -type f -name "tracking_*.txt" -exec sed -i "" -e "s/$OLD_TASK/$NEW_TASK/g" {} \;
    echo "Updated all matching task, $OLD_TASK to $NEW_TASK"
}

if [ $TYPE == "CURRENT" ]; then
    change_current_task $2
else
    change_all_matching_task $2 $3
fi