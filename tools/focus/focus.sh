#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

source $SCRIPT_DIR/communication.sh

if [[ $1 ]]; then
    mode=$1
else
    mode="pairing"
fi

FILE="$SCRIPT_DIR/focus"

if test -f "$FILE"; then
    echo "Stop focus mode"
    rm $FILE
    start_communication
else
    echo "Start focus mode"
    touch "$FILE"
    stop_communication
fi

cd $SCRIPT_DIR
cd ../
sh pomodoro_timer/pomodoro_timer.sh "END_IF_STOPPED"
