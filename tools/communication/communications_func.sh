#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [ -f "$SCRIPT_DIR/../tools.env" ]; then
    source "$SCRIPT_DIR/../tools.env"
else
    COMMUNICATIONS=("google")
fi

function start_communication() {
    for communication in ${COMMUNICATIONS[@]}; do
        if [[ $communication == "google" ]]; then
            sh "$SCRIPT_DIR/../browser/browser.sh" gmail
            sleep 1
            sh "$SCRIPT_DIR/../browser/browser.sh" gchat
            sleep 1
            sh "$SCRIPT_DIR/../browser/browser.sh" gcal
            sleep 1
        elif [[ $communication == "telegram" ]]; then
            sh "$SCRIPT_DIR/../browser/browser.sh" telegram
            sleep 1
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if [[ $communication == "slack" ]]; then
                open -a "Slack"
            elif [[ $communication == "discord" ]]; then
                open  -a Discord
            fi
        fi
    done
}

function stop_communication_from_browser() {
    osascript <<EOT
    tell windows of application "Google Chrome"
        close (tabs whose URL contain "https://mail.google.com")
        close (tabs whose URL contain "https://mail.google.com/chat/u/0/")
        close (tabs whose URL contain "https://calendar.google.com/calendar")
        close (tabs whose URL contain "https://web.telegram.org")
    end tell
EOT
} 

function stop_communication() {
    stop_communication_from_browser
    for communication in ${COMMUNICATIONS[@]}; do
        if [[ $communication == "slack" ]]; then
            killall Slack
        elif [[ $communication == "discord" ]]; then
            killall Discord
        fi
    done
}
