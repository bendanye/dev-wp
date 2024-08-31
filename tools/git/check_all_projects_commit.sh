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

is_all_projects_commit_push="true"

function check_project_commit() {
    PROJECT_NAME=$(basename "$PWD")

    BRANCH=$(git rev-parse --abbrev-ref HEAD)

    git fetch

    if [ "$(git log origin/$BRANCH..HEAD --oneline)" ]; then
        echo -e "${RED}$PROJECT_NAME ('$BRANCH') - There are commits that have not been pushed to the remote branch!${NO_COLOR}"
        is_all_projects_commit_push = "false"
    fi
}

echo "Checking projects' commits in $DIRECTORY"

for dir in "$DIRECTORY"/*; do
    if [ -d "$dir/.git" ]; then
        cd "$dir" || continue
        check_project_commit
    fi
done

if [[ $is_all_projects_commit_push == "true" ]]; then
    echo "All projects' commits in $DIRECTORY are pushed!"
fi
