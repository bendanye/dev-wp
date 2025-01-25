#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/../source.env"
source "$SCRIPT_DIR/../gitlab.env"
source "$SCRIPT_DIR/gitlab.sh"

if [ -f "$SCRIPT_DIR/../../tools.env" ]; then
    source "$SCRIPT_DIR/../../tools.env"
fi

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

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

while true
do
    result=$(curl -s -k --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "${GITLAB_URL}/api/v4/projects/${GITLAB_GROUP_ENCODING}${PROJECT}/pipelines/latest?ref=${BRANCH_NAME}")
    status=$(echo $result | jq -r '.status')
    id=$(echo $result | jq -r '.id')
    if [[ $status != "success" && $status != "failed" && $status != "canceled" ]]; then
        echo "${id}-${BRANCH_NAME} is still in progress. Sleep for 10 secs"
        sleep 10
    else
        echo "${id}-${BRANCH_NAME} is not running. Status is $status"
        break
    fi
done

if [[ $ALERTME_MAIN_FILE != "" ]]; then
    sh $ALERTME_MAIN_FILE
fi
