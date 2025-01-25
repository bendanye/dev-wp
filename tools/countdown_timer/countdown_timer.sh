#!/bin/bash

source "$SCRIPT_DIR/../source.env"

if [ -f "$SCRIPT_DIR/../../dwp.env" ]; then
    source "$SCRIPT_DIR/../../dwp.env"
fi

while getopts ":m:s:" opt; do
  case $opt in
    m) minutes="$OPTARG"
    ;;
    s) seconds="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ -z $minutes ]]; then
    echo "Default minutes to 1"
    minutes=1
fi

if [[ -z $seconds ]]; then
    echo "Default seconds to 0"
    seconds=0
fi

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

if [[ $ALERTME_MAIN_FILE != "" ]]; then
    sh $ALERTME_MAIN_FILE -m "Timer stopped"
fi
