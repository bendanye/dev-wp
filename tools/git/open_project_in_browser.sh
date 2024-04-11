#!/usr/bin/env bash

URL=$(git config --get remote.origin.url)

open  -a "Google Chrome" $URL
