#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file name expression> <optional - directory>"
    exit 1
fi

file_name_expression="$1"
directory="$2"

if [[ ! $directory ]]; then
    directory=$(pwd)
fi

if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' not found."
    exit 1
fi

echo "Finding $file_name_expression from $directory"

find $directory -iname $file_name_expression