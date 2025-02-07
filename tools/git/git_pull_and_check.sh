#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [ -f "$SCRIPT_DIR/../tools.env" ]; then
    source "$SCRIPT_DIR/../tools.env"
    DIRECTORY=$WORKING_DIR
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
if [[ -f "$LAST_COMMIT_FILE" && "$LAST_COMMIT_HASH" == "$(cat $LAST_COMMIT_FILE)" ]]; then
    exit 0
fi

# Check if package.json has changed in the last pull
if git diff --name-only "$LAST_COMMIT_HASH" "$NEW_COMMIT_HASH" | grep -q "package.json"; then
    echo "package.json has changed! Running npm install."
    rm -rf node_modules
    npm install
fi

# Save the new commit hash
echo "$NEW_COMMIT_HASH" > "$LAST_COMMIT_FILE"
