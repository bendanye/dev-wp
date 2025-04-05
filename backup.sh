#!/bin/bash

rm -rf backup
mkdir -p backup

function backup_learning() {
    cd work_logs
    python3 create_learnings.py
    cp learning.md ../backup
    echo "Learning backup is completed."
}

function backup_logs() {
    for dir in */; do
        case "$dir" in
            backup/|katas/|other_tools/|tools/|work_logs/) ;;
            *) cp -r $dir backup/$dir ;;
        esac
    done

    mkdir -p backup/time_tracker/bkup
    cp -r tools/time_tracker/bkup backup/time_tracker
    cp -r tools/time_tracker/*.txt backup/time_tracker

    mkdir -p backup/work_logs/logs
    cp -r work_logs/logs backup/work_logs

    echo "Full backup is completed."
}