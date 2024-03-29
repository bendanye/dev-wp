#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

function open_fav_tabs() {
    open  -a "Google Chrome" "https://www.youtube.com/playlist?list=PLv4wZaT1eIwVdqdt6ROKj5k4VNAOqli3k"
    sleep 1
}

function open_communication() {
    open  -a "Google Chrome" "https://mail.google.com/mail/u/0/?tab=rm&ogbl"
    sleep 1
    open  -a "Google Chrome" "https://mail.google.com/chat/u/0/"
    sleep 1
    open  -a "Google Chrome" "https://calendar.google.com/calendar/u/0/r"
    sleep 1
    open  -a "Slack"
    sleep 1
}

function open_daily_reading_news_tabs() {
    open  -a "Google Chrome" "https://www.espn.com.sg/football"
    sleep 1
    open  -a "Google Chrome" "https://www.channelnewsasia.com/singapore"
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

function backup_pomodoro_timer_files() {
    cd $SCRIPT_DIR
    sh ../pomodoro_timer/backup.sh
}

function open_daily_tech_note() {
    cd ~/IdeaProjects/renotes
    sh open_random.sh tech
}

function show_today_kata() {
    cd $SCRIPT_DIR
    sh ../../katas/daily_summary.sh
}

open_communication
open_fav_tabs
open_daily_reading_news_tabs
open_freq_used_apps
open_ide
sleep 2

backup_pomodoro_timer_files

# colima start --cpu 4 --memory 8 --disk 100

open_daily_tech_note

open  -a "xbar"

show_today_kata
