#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/communications_func.sh"

if [[ $1 == "on" ]]; then
    echo "To switch on communication"
    start_communication
elif [[ $1 == "off" ]]; then
    echo "To switch off communication"
    stop_communication
else
    echo "Either use on or off"
fi