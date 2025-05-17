#!/usr/bin/env bash

URL=$(git config --get remote.origin.url)

if [[ $URL == https* ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open -a "Google Chrome" "$URL"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin"* ]]; then
        start "$URL"
    else
        echo "Unsupported operating system"
    fi
else
    echo "Unable to open. It Does not starts with https"
fi
