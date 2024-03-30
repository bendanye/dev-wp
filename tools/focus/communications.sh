#!/bin/bash

communications=("google")

function start_communication() {
    for communication in ${communications[@]}; do
        if [[ $communication == "google" ]]; then
            stop_communication_from_browser
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
    for communication in ${communications[@]}; do
        if [[ $communication == "google" ]]; then
            stop_communication_from_browser
        elif [[ $communication == "slack" ]]; then
            killall Slack
        fi
    done
}
