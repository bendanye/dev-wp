#!/usr/bin/env bash

if [ -n "$1" ]; then
    PROJECT=$1
else
    PROJECT=$(basename `git rev-parse --show-toplevel`)
fi

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/../gitlab.env"

URL=$(git config --get remote.origin.url)
if [[ $URL != https* ]]; then
    GITLAB_GROUP=${URL#*:}
    GITLAB_GROUP=${GITLAB_GROUP%/*}
fi

open  -a "Google Chrome" "${GITLAB_URL}/${GITLAB_GROUP}/${PROJECT}"
