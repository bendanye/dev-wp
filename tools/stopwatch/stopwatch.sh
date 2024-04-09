#!/bin/bash

minutes=0
seconds=0

while true; do

    ((seconds++))

    if [ $seconds -eq 60 ]; then
        seconds=0
        ((minutes++))
    fi
    
    printf "\r%02d:%02d (press space to exit)" $minutes $seconds
    IFS="\n"
    read -s -n 1 -t 1 key
    if [ "$key" == " " ]; then
        break
    fi
    IFS=""
done
