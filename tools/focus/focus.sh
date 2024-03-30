#!/bin/bash

communications=("google")

function start_communication() {
    for communication in ${communications[@]}; do
        if [[ $communication == "google" ]] ; then
            open  -a "Google Chrome" "https://mail.google.com/mail/u/0/?tab=rm&ogbl"
            sleep 1
            open  -a "Google Chrome" "https://mail.google.com/chat/u/0/"
            sleep 1
            open  -a "Google Chrome" "https://calendar.google.com/calendar/u/0/r"
            sleep 1

        elif if [[ $communication == "slack" ]] ; then
            open  -a "Slack"
        fi
    done
}

function stop_communication_from_browser() {
    osascript <<EOT
    tell windows of application "Google Chrome"
        close (tabs whose URL contain "https://mail.google.com")
        close (tabs whose URL contain "https://calendar.google.com/calendar")
    end tell
EOT
} 

function stop_communication_for_solo() {
    echo "Stop Communication to solo"
    for communication in ${communications[@]}; do
        if [[ $communication == "google" ]] ; then
            stop_communication_from_browser
        elif if [[ $communication == "slack" ]] ; then
            killall Slack
        fi
    done
}

function stop_communication_for_pairing() {
    echo "Stop Communication to pair"
    for communication in ${communications[@]}; do
        if [[ $communication == "google" ]] ; then
            stop_communication_from_browser
        elif if [[ $communication == "slack" ]] ; then
            killall Slack
        fi
    done
}

if [[ $1 ]]; then
    mode=$1
else
    mode="pairing"
fi

SCRIPT_DIR=$( dirname -- "$0"; )

FILE="$SCRIPT_DIR/focus"

if test -f "$FILE"; then
    echo "Stop focus mode"
    rm $FILE
    start_communication
else
    echo "Start focus mode"
    touch "$FILE"
    if [[ $mode == "solo" ]]; then
        stop_communication_for_solo
    else
        stop_communication_for_pairing
    fi
fi

cd $SCRIPT_DIR
cd ../
sh pomodoro_timer/pomodoro_timer.sh "END_IF_STOPPED"
