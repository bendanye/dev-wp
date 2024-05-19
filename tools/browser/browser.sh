#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [[ -z $1 ]]; then
    echo "Please specify the key for the url"
    exit 1
fi

file="$SCRIPT_DIR/url.properties"

function get_url {
    echo $(grep "${1}" ${file} | cut -d'=' -f2)
}

URL=$(get_url $1)

if [[ -z $URL ]]; then
    echo "No url exists for $1"
    exit 1
fi

open  -a "Google Chrome" "$URL"