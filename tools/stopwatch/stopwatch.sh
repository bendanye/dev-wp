#!/bin/bash

minutes=0
seconds=0

while true; do
    
    printf "\r%02d:%02d" $minutes $seconds

    ((seconds++))

    if [ $seconds -eq 60 ]; then
        seconds=0
        ((minutes++))
    fi
    
    sleep 1
done