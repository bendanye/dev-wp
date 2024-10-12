#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

source $SCRIPT_DIR/../communication/communications.sh

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

function open_freq_used_apps() {
    open ~/Desktop/MacPass.app
    open -a "Notes"

    if test -d $SCRIPT_DIR/../../other_tools/yet-another-dev-productivity-tools; then
        cd $SCRIPT_DIR/../../other_tools/yet-another-dev-productivity-tools
        sh run.sh
    fi
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
    if [ ! -d "$SCRIPT_DIR/../../tasks/renotes" ]; then
        echo "renotes folder does not exists."
        return 1
    fi

    cd $SCRIPT_DIR/../../tasks/renotes
    git pull
    sh open_random.sh tech
}

function check_tasks() {
    cd $SCRIPT_DIR/../tools/time_tracker
    sh check_yesterday.sh
}

function show_today_kata() {
    cd $SCRIPT_DIR
    sh ../../katas/daily_schedule.sh
}

function start_work_related_activity() {
    cd $SCRIPT_DIR/../git
    sh check_all_projects_commit.sh
    sh check_all_projects_branch.sh

    # To add work related activities such as opening a page, add key
}

update_katas_git_repos
update_other_tools_git_repos
start_communication
open_daily_reading_news_tabs
open_freq_used_apps
open_ide
sleep 2

backup_time_tracker_files

# colima start --cpu 4 --memory 8 --disk 100

open_daily_tech_note
check_tasks

open  -a "xbar"

show_today_kata

start_work_related_activity
