#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [ -f "$SCRIPT_DIR/../source.env" ]; then
    source "$SCRIPT_DIR/../source.env"
    DIRECTORY=$GIT_PROJECT_DIR
else
    DIRECTORY=~/IdeaProjects
fi

for dir in "$DIRECTORY"/*; do
    if [ -d "$dir/.git" ]; then
        cd "$dir" || continue
        PROJECT_NAME=$(basename "$PWD")
        echo "git pull $PROJECT_NAME"
        git pull
    fi
done