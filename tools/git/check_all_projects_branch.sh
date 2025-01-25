#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [ -f "$SCRIPT_DIR/../../dwp.env" ]; then
    source "$SCRIPT_DIR/../../dwp.env"
fi

if [ -f "$SCRIPT_DIR/../tools.env" ]; then
    source "$SCRIPT_DIR/../tools.env"
    DIRECTORY=$GIT_PROJECT_DIR
else
    DIRECTORY=~/IdeaProjects
fi

# Define color codes
RED='\033[0;31m'
RESET='\033[0m'

check_results=()

function check_project_branch() {
    PROJECT_NAME=$(basename "$PWD")

    BRANCH=$(git rev-parse --abbrev-ref HEAD)

    if [[ "$BRANCH" != "master" ]] && [[ "$BRANCH" != "main" ]]; then
        check_results+=("$PROJECT_NAME")
    fi
}

echo "Checking projects' branch in $DIRECTORY"

for dir in "$DIRECTORY"/*; do
    if [ -d "$dir/.git" ]; then
        cd "$dir" || continue
        check_project_branch
    fi
done

if [[ ${#check_results[@]} -eq 0 ]]; then
    echo "All projects' in $DIRECTORY are in master/main!"
else
    for result in "${check_results[@]}"; do
        MESSAGE="${result} is not in master/main branch"
        echo -e "${RED}${MESSAGE}${RESET}"
        if [[ $TODO_MAIN_FILE != "" ]]; then
            sh "${TODO_MAIN_FILE}" "$MESSAGE"
        fi
    done
fi

