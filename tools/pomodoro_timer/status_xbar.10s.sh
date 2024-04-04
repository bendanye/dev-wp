#!/bin/bash

# <xbar.title>Pomodoro Timer Status</xbar.title>
# <xbar.author>Benjamin Ng</xbar.author>
# <xbar.author.github>bendanye</xbar.author.github>

SCRIPT_DIR=$( dirname -- "$0"; )

source $SCRIPT_DIR/env/pomodoro_timer.env

FILE="$SOURCE_DIR/timer"
if test -f "$FILE"; then
    START=$(cat $FILE)
    END=$(date +%s)
    DURATION=$((END-START))
    MINUTES=$(($DURATION / 60))
    if [[ $MINUTES -ge 50 ]]; then
        echo "$MINUTES | color=darkred"
    elif [[ $MINUTES -ge 25 ]]; then
        echo "$MINUTES | color=darkgreen"
    else
        echo "🍅"
        echo "---"
        START=$(cat $FILE)
        END=$(date +%s)
        DURATION=$((END-START))
        echo "$(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds | color=darkgreen"
    fi
else
    echo "⏹"
fi 
