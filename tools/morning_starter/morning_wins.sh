#!/usr/bin/env bash

if [[ $OSTYPE == "darwin"* ]]; then
    SCRIPT_DIR="$(dirname "$0")"
elif [[ "$OSTYPE" == "win32" ]]; then
    echo "Please uncomment and set SCRIPT_DIR for windowa"
    SCRIPT_DIR=""
fi

source $SCRIPT_DIR/../communication/communications_func.sh

function update_katas_git_repos() {
    cd $SCRIPT_DIR/../../katas
    sh update_repos.sh
}

function update_other_tools_git_repos() {
    if test -d $SCRIPT_DIR/../../other_tools; then
        cd $SCRIPT_DIR/../git
        sh git_pull_all_projects.sh $SCRIPT_DIR/../../other_tools
    fi
}

function open_daily_reading_news_tabs() {
    sh $SCRIPT_DIR/../browser/browser.sh so
    sleep 1
    sh $SCRIPT_DIR/../browser/browser.sh cna
    sleep 1
}

function backup_time_tracker_files() {
    cd $SCRIPT_DIR
    sh ../time_tracker/backup.sh
}

function create_work_log_file() {
    if [ ! -d "$SCRIPT_DIR/../../work_logs" ]; then
        echo "work_logs folder does not exists."
        return 1
    fi

    cd $SCRIPT_DIR/../../work_logs
    python3 create_work_log_file.py
}

function open_daily_tech_note() {
    if [ ! -d "$SCRIPT_DIR/../../other_tools/renotes" ]; then
        echo "renotes folder does not exists."
        return 1
    fi

    cd $SCRIPT_DIR/../../other_tools/renotes
    sh open_random.sh tech
}

function check_tasks() {
    cd $SCRIPT_DIR/../../tools/time_tracker
    sh check_yesterday.sh

    if [ ! -d "$SCRIPT_DIR/../../work_logs" ]; then
        echo "work_logs folder does not exists."
        return 1
    fi
    cd $SCRIPT_DIR/../../work_logs
    sh daily_check.sh
}

function show_today_kata() {
    if [ ! -d "$SCRIPT_DIR/../../katas" ]; then
        echo "katas folder does not exists."
        return 1
    fi

    cd $SCRIPT_DIR
    sh ../../katas/daily_schedule.sh
}

function start_work_related_activity() {
    # To add work related activities such as opening a page, add key

    cd $SCRIPT_DIR/../git
    sh check_all_projects_commit.sh
    sh check_all_projects_branch.sh
}

update_katas_git_repos
update_other_tools_git_repos
start_communication
open_daily_reading_news_tabs
sleep 2

backup_time_tracker_files
create_work_log_file

open_daily_tech_note
check_tasks

show_today_kata

# start_work_related_activity
