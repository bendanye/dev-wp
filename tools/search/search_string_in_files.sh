#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory> <word>"
    exit 1
fi

search_word_in_file() {
    local file="$1"
    local word="$2"
    # Check if the file contains the specified word
    if grep -q "$word" "$file"; then
        echo "Found in: $file"
    fi
}

search_word_in_directory() {
    local directory="$1"
    local word="$2"
    # Iterate through files in the directory
    for file in "$directory"/*; do
        if [ -d "$file" ]; then
            # If it's a directory, recursively search it
            search_word_in_directory "$file" "$word"
        elif [ -f "$file" ]; then
            # If it's a file, search for the word in it
            search_word_in_file "$file" "$word"
        fi
    done
}

directory="$1"
word="$2"
if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' not found."
    exit 1
fi
# Perform the search
search_word_in_directory "$directory" "$word"
