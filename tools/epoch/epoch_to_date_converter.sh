#!/bin/bash

# Check if an argument (epoch time) is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <epoch_time>"
  exit 1
fi

EPOCH_TIME="$1"

# Detect OS type
OS_TYPE="$(uname)"

# Convert epoch to date depending on OS
case "$OS_TYPE" in
  Darwin)
    # macOS
    DATE_OUTPUT=$(date -r "$EPOCH_TIME" "+%Y-%m-%d %H:%M:%S")
    ;;
  MINGW*|MSYS*|CYGWIN*)
    # Git Bash (Windows)
    DATE_OUTPUT=$(date -d @"$EPOCH_TIME" "+%Y-%m-%d %H:%M:%S")
    ;;
  Linux)
    # Linux
    DATE_OUTPUT=$(date -d @"$EPOCH_TIME" "+%Y-%m-%d %H:%M:%S")
    ;;
  *)
    echo "Unsupported OS: $OS_TYPE"
    exit 2
    ;;
esac

# Check for errors
if [ $? -ne 0 ]; then
  echo "Invalid epoch time: $EPOCH_TIME"
  exit 3
fi

# Output
echo "Date : $DATE_OUTPUT"