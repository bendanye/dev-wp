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

GITLAB_GROUP_ENCODING=$(echo "$GITLAB_GROUP/" | sed 's#/#%2F#g')

curl -s -k --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "${GITLAB_URL}/api/v4/projects/${GITLAB_GROUP_ENCODING}${PROJECT}/remote_mirrors" | jq first | jq -r '.update_status'
