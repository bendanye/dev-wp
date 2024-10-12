#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [ -f "$SCRIPT_DIR/../source.env" ]; then
    source "$SCRIPT_DIR/../source.env"
    DIRECTORY=$GIT_PROJECT_DIR
else
    DIRECTORY=~/IdeaProjects
fi

echo "Get project's with commit in the last 24 hours in $DIRECTORY"

# Get the current time in seconds
CURRENT_TIME=$(date +%s)

# Set the time period to 24 hours (86400 seconds)
TIME_PERIOD=$((24 * 60 * 60))

# Loop through each directory in the specified folder
for project in "$DIRECTORY"/*; do
  if [ -d "$project/.git" ]; then
    # Get the last commit timestamp in seconds
    LAST_COMMIT_TIMESTAMP=$(git -C "$project" log -1 --format=%ct)
    
    # Calculate the time difference
    TIME_DIFF=$((CURRENT_TIME - LAST_COMMIT_TIMESTAMP))
    
    # Check if the time difference is less than 24 hours
    if [ "$TIME_DIFF" -lt "$TIME_PERIOD" ]; then
      # Print the project name if the commit was within 24 hours
      echo "$(basename "$project")"
    fi
  fi
done
