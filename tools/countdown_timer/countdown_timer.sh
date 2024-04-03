#!/bin/bash

if [[ -z $1 ]]; then
    minutes=0
else
    minutes=$1
fi

seconds=0

while true; do
    printf "\r%02d:%02d" $minutes $seconds

    ((seconds--))

    if [ $seconds -lt 0 ]; then
        if [ $minutes -le 0 ]; then
            break
        fi

        seconds=59
        ((minutes--))
    fi
    
    sleep 1
done

echo ""
echo "Timer stopped"