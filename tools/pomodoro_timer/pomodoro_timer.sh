#!/bin/bash
SCRIPT_DIR=$( dirname -- "$0"; )

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

DATA_FILE=$(get_file)
if ! test -f "$DATA_FILE"; then
    echo "start_date,desk_minutes" > $DATA_FILE
fi

TIMER_FILE="$SCRIPT_DIR/timer"
if test -f "$TIMER_FILE"; then
    echo "Stop timer"
    START=$(cat $TIMER_FILE)
    rm $TIMER_FILE
    END=$(date +%s)
    secs=$((END-START))
    working_time=$(( secs/60 ))
    resting_time=$(( working_time/5 ))
    rest_until=$(date "-v+$resting_time"M '+%H:%M')

    echo "Total at my desk time: $working_time minutes"
    echo "Please check your communication tools and take a break for $resting_time minutes until $rest_until"

    START_FORMATTED=$(date -r $START '+%Y-%m-%d %H:%M:%S')
    echo "$START_FORMATTED,$working_time" >> $DATA_FILE

    cd $SCRIPT_DIR
    sh ../stopwatch/stopwatch.sh
else
    echo "Start timer"
    START=$(date +%s)
    echo $START > $TIMER_FILE
    sh "$SCRIPT_DIR/status.sh"
fi
