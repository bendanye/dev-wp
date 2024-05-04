#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [ -f "$SCRIPT_DIR/../source.env" ]; then
    source "$SCRIPT_DIR/../source.env"
else
    COMMUNICATIONS=("google")
fi

function start_communication() {
    for communication in ${COMMUNICATIONS[@]}; do
        if [[ $communication == "google" ]]; then
            open  -a "Google Chrome" "https://mail.google.com/mail/u/0/?tab=rm&ogbl"
            sleep 1
            open  -a "Google Chrome" "https://mail.google.com/chat/u/0/"
            sleep 1
            open  -a "Google Chrome" "https://calendar.google.com/calendar/u/0/r"
            sleep 1
        elif [[ $communication == "slack" ]]; then
            killall Slack
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

function stop_communication() {
    for communication in ${COMMUNICATIONS[@]}; do
        if [[ $communication == "google" ]]; then
            stop_communication_from_browser
        elif [[ $communication == "slack" ]]; then
            killall Slack
        fi
    done
}

echo $COMMUNICATIONS