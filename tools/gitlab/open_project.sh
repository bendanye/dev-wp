#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/../gitlab.env"

if [ -n "$1" ]; then
    source "$SCRIPT_DIR/../source.env"
    PROJECT=$1
    cd "$GIT_PROJECT_DIR/$PROJECT"
else
    PROJECT=$(basename `git rev-parse --show-toplevel`)
fi

URL=$(git config --get remote.origin.url)
if [[ $URL != https* ]]; then
    GITLAB_GROUP=${URL#*:}
    GITLAB_GROUP=${GITLAB_GROUP%/*}
fi

open  -a "Google Chrome" "${GITLAB_URL}/${GITLAB_GROUP}/${PROJECT}"
