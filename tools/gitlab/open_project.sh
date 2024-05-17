#!/usr/bin/env bash

if [ -n "$1" ]; then
    PROJECT=$1
else
    PROJECT=$(basename `git rev-parse --show-toplevel`)
fi

URL=$(git config --get remote.origin.url)

cd "$(dirname "$0")"

source ../gitlab.env

if [[ $GITLAB_GROUP == "" ]]; then
    GITLAB_GROUP=${URL#*:}
    GITLAB_GROUP=${GITLAB_GROUP%/*}
fi

open  -a "Google Chrome" "${GITLAB_URL}/${GITLAB_GROUP}/${PROJECT}"
