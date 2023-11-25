#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <FOLDER_PATH> <STRING_TO_SEARCH>"
    exit 1
fi

FOLDER_PATH=$1
STRING_TO_SEARCH=$2

# Use find to locate files in the specified folder and subdirectories, and grep to search for content
find "$FOLDER_PATH" -type f -exec grep -l "$STRING_TO_SEARCH" {} + 2>/dev/null
