#!/usr/bin/env bash

# Default to 0 minutes if no argument is given
MINUTES_TO_SUBTRACT=${1:-0}

# Get current epoch time
CURRENT_EPOCH=$(date +%s)

# Convert minutes to seconds and subtract
SECONDS_TO_SUBTRACT=$((MINUTES_TO_SUBTRACT * 60))
NEW_EPOCH=$((CURRENT_EPOCH - SECONDS_TO_SUBTRACT))

echo "Current epoch time: $CURRENT_EPOCH"
echo "Epoch time after subtracting $MINUTES_TO_SUBTRACT minute(s): $NEW_EPOCH"
