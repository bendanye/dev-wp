#!/usr/bin/env bash

URL=$(git config --get remote.origin.url)

if [[ $URL == https* ]]; then
    open  -a "Google Chrome" $URL
else
    echo "Unable to open. It Does not starts with https"
fi
