#!/bin/bash
SCRIPT_DIR=$( dirname -- "$0"; )

cd $SCRIPT_DIR

if [ ! -d "$directory_path" ]; then
    mkdir bkup
fi

mv working_*.txt bkup