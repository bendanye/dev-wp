#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/../source.env"
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

while true
do
    status=$(curl -s -k --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "${GITLAB_URL}/api/v4/projects/${GITLAB_GROUP_ENCODING}${PROJECT}/pipelines" | jq first | jq -r '.status')
    if [[ $status != "success" && $status != "failed" && $status != "canceled" ]]; then
        echo "Still in progress. Sleep for 10 secs"
        sleep 10
    else
        echo "No more running. Status is $status"
        break
    fi
done

if [[ $ALERTME_MAIN_FILE != "" ]]; then
    sh $ALERTME_MAIN_FILE
fi
