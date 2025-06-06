#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

function open_freq_used_apps() {
    open ~/Desktop/MacPass.app
    open -a "Notes"

    if test -d "$SCRIPT_DIR/../../other_tools/yet-another-dev-productivity-tools"; then
        cd "$SCRIPT_DIR/../../other_tools/yet-another-dev-productivity-tools"
        nohup sh run.sh &
    fi
}

function open_ide() {
    open -a "IntelliJ IDEA CE"

    cd "$SCRIPT_DIR"
    cd ../../
    code .
}

function start_work_related_activity() {
    # To add work related activities such as opening a page, add key
}

open_freq_used_apps
open_ide
sleep 2

# colima start --cpu 4 --memory 8 --disk 100

open  -a "xbar"

start_work_related_activity
