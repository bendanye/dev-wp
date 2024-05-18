#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/../gitlab.env"
source "$SCRIPT_DIR/gitlab.sh"

if [ -n "$1" ]; then
    PROJECT=$1
    FROM="TERMINAL"
else
    PROJECT=$(basename `git rev-parse --show-toplevel`)
    FROM="DIRECTORY"
fi

GITLAB_GROUP=$(get_group_name $PROJECT $FROM)

if [[ $GITLAB_GROUP == *"Unable to determine the project url"* ]]; then
    echo $GITLAB_GROUP
    exit 1
fi 

open -a "Google Chrome" "${GITLAB_URL}/${GITLAB_GROUP}/$PROJECT/-/merge_requests?assignee_username=${GITLAB_GROUP_USER_NAME}"