#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [ -f "$SCRIPT_DIR/../../tools.env" ]; then
    source "$SCRIPT_DIR/../../tools.env"
fi

if [ -f "$SCRIPT_DIR/../source.env" ]; then
    source "$SCRIPT_DIR/../source.env"
    DIRECTORY=$GIT_PROJECT_DIR
else
    DIRECTORY=~/IdeaProjects
fi

# Define color codes
RED='\033[0;31m'
RESET='\033[0m'

check_results=()

function check_project_commit() {
    PROJECT_NAME=$(basename "$PWD")

    BRANCH=$(git rev-parse --abbrev-ref HEAD)

    git fetch

    if [ "$(git log origin/$BRANCH..HEAD --oneline)" ]; then
        check_results+=("$PROJECT_NAME - $BRANCH")
    fi
}

echo "Checking projects' commits in $GIT_PROJECT_DIR"

for dir in "$DIRECTORY"/*; do
    if [ -d "$dir/.git" ]; then
        cd "$dir" || continue
        check_project_commit
    fi
done

if [[ ${#check_results[@]} -eq 0 ]]; then
    echo "All projects' commits in $GIT_PROJECT_DIR are pushed!"
else
    for result in "${check_results[@]}"; do
        MESSAGE="${result} - There are commits that have not been pushed to the remote branch!"
        echo -e "${RED}${MESSAGE}${RESET}"
        if [[ $TODO_MAIN_FILE != "" ]]; then
            sh "${TODO_MAIN_FILE}" "$MESSAGE"
        fi
    done
fi
