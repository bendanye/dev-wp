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
    if [[ $MINUTES -ge 25 ]]; then
        echo "$MINUTES | color=red"
    else
        echo "🍅"
    fi
else
    echo "⏹"
fi 
