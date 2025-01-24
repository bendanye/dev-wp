#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

function open_freq_used_apps() {
    open ~/Desktop/MacPass.app
    open -a "Notes"
}

function open_ide() {
    open -a "IntelliJ IDEA CE"

    cd $SCRIPT_DIR
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

start_work_related_activity
