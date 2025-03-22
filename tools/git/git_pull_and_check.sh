#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [ -f "$SCRIPT_DIR/../tools.env" ]; then
    source "$SCRIPT_DIR/../tools.env"
    DIRECTORY=$PROJECT_WORKING_DIR
else
    DIRECTORY=~/IdeaProjects
fi

repo_name=$(basename `git rev-parse --show-toplevel`)

# File to store the last checked commit hash
LAST_COMMIT_FILE="${DIRECTORY}/.${repo_name}_last_checked_commit"

# Get the latest commit hash before pulling
LAST_COMMIT_HASH=$(git rev-parse HEAD)

# Perform git pull
git pull

# Get the latest commit hash after pulling
NEW_COMMIT_HASH=$(git rev-parse HEAD)

# If the commit didn't change, exit quietly
if [[ -f "$LAST_COMMIT_FILE" && "$NEW_COMMIT_HASH" == "$(cat $LAST_COMMIT_FILE)" ]]; then
    exit 0
fi

CHANGED_FILES=$(git diff --name-only HEAD@{1} HEAD)

# Check if package.json has changed in the last pull
if echo "$CHANGED_FILES" | grep -q "package.json"; then
    echo "package.json has changed! Running npm install."
    rm -rf node_modules
    npm install
fi

# Save the new commit hash
echo "$NEW_COMMIT_HASH" > "$LAST_COMMIT_FILE"
