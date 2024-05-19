#!/bin/bash

# <xbar.title>Pomodoro Timer Status</xbar.title>
# <xbar.author>Benjamin Ng</xbar.author>
# <xbar.author.github>bendanye</xbar.author.github>

SCRIPT_DIR=$( dirname -- "$0"; )

source $SCRIPT_DIR/env/pomodoro_timer.env

TIMER_FILE="$SOURCE_DIR/../timer"
if test -f "$TIMER_FILE"; then
    START=$(cat $TIMER_FILE | cut -d ',' -f1)
    END=$(date +%s)
    DURATION=$((END-START))
    MINUTES=$(($DURATION / 60))
    if [[ $MINUTES -ge 50 ]]; then
        echo "$MINUTES | color=darkred"
    elif [[ $MINUTES -ge 25 ]]; then
        echo "$MINUTES | color=darkgreen"
    else
        echo "🍅"
    fi
    
    echo "---"
    START=$(cat $TIMER_FILE | cut -d ',' -f1)
    CURRENT_TASK=$(cat $TIMER_FILE | cut -d ',' -f2)
    END=$(date +%s)
    DURATION=$((END-START))
    if [[ $CURRENT_TASK == "MISC" ]]; then
        echo "$(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds | color=darkgreen"
    else
        echo "$CURRENT_TASK - $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds | color=darkgreen"
    fi
else
    echo "⏹"
fi 
