#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [ -f "$SCRIPT_DIR/../source.env" ]; then
    source "$SCRIPT_DIR/../source.env"
    DIRECTORY=$GIT_PROJECT_DIR
else
    DIRECTORY=~/IdeaProjects
fi

# Define color codes
RED='\033[0;31m'
NO_COLOR='\033[0m'

is_all_projects_master_branch="true"

function check_project_branch() {
    PROJECT_NAME=$(basename "$PWD")

    BRANCH=$(git rev-parse --abbrev-ref HEAD)

    if [[ "$BRANCH" != "master" ]] && [[ "$BRANCH" != "main" ]]; then
        echo -e "${RED}$PROJECT_NAME - Not on master/main branch but instead on $BRANCH"
        is_all_projects_master_branch="false"
    fi
}

echo "Checking projects' branch in $DIRECTORY"

for dir in "$DIRECTORY"/*; do
    if [ -d "$dir/.git" ]; then
        cd "$dir" || continue
        check_project_branch
    fi
done

if [[ $is_all_projects_master_branch == "true" ]]; then
    echo "All projects' in $DIRECTORY are in master/main!"
fi
