#!/bin/bash

# <xbar.title>Pomodoro Timer Status</xbar.title>
# <xbar.author>Benjamin Ng</xbar.author>
# <xbar.author.github>bendanye</xbar.author.github>

SCRIPT_DIR=$( dirname -- "$0"; )

FILE="$SCRIPT_DIR/timer"
if test -f "$FILE"; then
    echo "🍅"
else
    echo "⏹"
fi 
