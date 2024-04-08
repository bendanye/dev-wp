#!/usr/bin/env bash

if [ -n "$1" ]; then
    PROJECT=$1
else
    PROJECT=$(basename `git rev-parse --show-toplevel`)
fi

cd "$(dirname "$0")"

source ../gitlab.env

while true
do
    status=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "${GITLAB_URL}/api/v4/projects/${GITLAB_GROUP_ENCODING}${PROJECT}/pipelines" | jq first | jq -r '.status')
    if [[ $status != "success" && $status != "failed" && $status != "canceled" ]]; then
        echo "Still in progress. Sleep for 10 secs"
        sleep 10
    else
        echo "No more running. Status is $status"
        break
    fi
done

# Can call another script to alert