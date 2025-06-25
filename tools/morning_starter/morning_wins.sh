#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/../communication/communications_func.sh"

function katas_git_repos() {
    cd "$SCRIPT_DIR/../../katas"
    python3 update_repos.py
    python3 daily_schedule.py
}

function update_other_tools_git_repos() {
    if test -d "$SCRIPT_DIR/../other_tools"; then
        cd "$SCRIPT_DIR/../tools/git"
        sh git_pull_all_projects.sh "$SCRIPT_DIR/../../other_tools"
    fi
}

function open_daily_reading_news_tabs() {
    sh "$SCRIPT_DIR/../browser/browser.sh" so
    sleep 1
    sh "$SCRIPT_DIR/../browser/browser.sh" cna
    sleep 1
}


function open_ide() {
    code "$SCRIPT_DIR/../../"
}

function backup_time_tracker_files() {
    cd "$SCRIPT_DIR"
    sh ../time_tracker/backup.sh
}

function open_daily_tech_note() {
    if [ ! -d "$SCRIPT_DIR/../../other_tools/renotes" ]; then
        echo "renotes folder does not exists."
        return 1
    fi

    cd "$SCRIPT_DIR/../../other_tools/renotes"
    python3 open_random.py tech
}

function check_tasks() {
    cd "$SCRIPT_DIR/../../tools/time_tracker"
    sh check_yesterday.sh

    if [ ! -d "$SCRIPT_DIR/../../work_logs" ]; then
        echo "work_logs folder does not exists."
        return 1
    fi
    cd "$SCRIPT_DIR/../../work_logs"
    sh daily_check.sh
}

function start_work_related_activity() {
    # To add work related activities such as opening a page, add key

    cd "$SCRIPT_DIR/../git"
    sh check_all_projects_commit.sh
    sh check_all_projects_branch.sh
}

function start_time_tracker_tray_icon() {
    cd "$SCRIPT_DIR/../../tools/time_tracker/pystray"
    python3 time_tracker.py
}

start_communication
open_daily_reading_news_tabs
sleep 2

open_ide

check_tasks
backup_time_tracker_files
open_daily_tech_note

katas_git_repos
update_other_tools_git_repos

# start_work_related_activity
start_time_tracker_tray_icon