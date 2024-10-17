#!/bin/bash

# Check if the file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Initialize line counter
line_number=1

# Read the file line by line
while IFS= read -r line; do
    length=${#line}
    echo "Line $line_number Length: $length"
    ((line_number++))
done < "$1"
