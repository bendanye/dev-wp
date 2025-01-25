#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [ -n "$1" ]; then
    PROJECT=$1
    if [ -f "$SCRIPT_DIR/../tools.env" ]; then
        source "$SCRIPT_DIR/../tools.env"
    else
        GIT_PROJECT_DIR="$HOME/IdeaProjects"
    fi
    cd $GIT_PROJECT_DIR/$PROJECT
fi

LAST_COMMIT_MSG=$(git log -1 --pretty=%B | cat | tr '\n' ' ')
echo "Copied: $LAST_COMMIT_MSG"
echo $LAST_COMMIT_MSG | pbcopy