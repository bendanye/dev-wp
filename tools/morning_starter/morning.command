#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

source $SCRIPT_DIR/../communication/communications.sh

function open_daily_reading_news_tabs() {
    sh $SCRIPT_DIR/../browser/browser.sh so
    sleep 1
    sh $SCRIPT_DIR/../browser/browser.sh cna
    sleep 1
}

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

function backup_time_tracker_files() {
    cd $SCRIPT_DIR
    sh ../time_tracker/backup.sh
}

function open_daily_tech_note() {
    cd ~/IdeaProjects/renotes
    sh open_random.sh tech
}

function show_today_kata() {
    cd $SCRIPT_DIR
    sh ../../katas/daily_schedule.sh
}

start_communication
open_daily_reading_news_tabs
open_freq_used_apps
open_ide
sleep 2

backup_time_tracker_files

# colima start --cpu 4 --memory 8 --disk 100

open_daily_tech_note

open  -a "xbar"

show_today_kata
