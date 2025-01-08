#!/usr/bin/env bash

#<xbar.title>Monitor Gitlab Builds</xbar.title>
#<xbar.author>Benjamin Ng</xbar.author>
#<xbar.dependencies>jq</xbar.dependencies>

cd "$(dirname "$0")"

source env/gitlab.env
# source ../../gitlab.env

# source "../gitlab.sh"

set -eu

test "$GITLAB_ACCESS_TOKEN"
test "$GITLAB_URL"

# Specified list of projects
PROJECTS=()

GITLAB_GROUP=""

GITLAB_GROUP_ENCODING=$(echo "$GITLAB_GROUP/" | sed 's#/#%2F#g')

pipeline_results=()

function get_pipeline_status() {
    for project in ${PROJECTS[@]}; do
        status=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "${GITLAB_URL}/api/v4/projects/${GITLAB_GROUP_ENCODING}${project}/pipelines" | /opt/homebrew/bin/jq first | /opt/homebrew/bin/jq -r '.status')
        pipeline_results+=("$project - $status")
    done
}

function print_header() {
    if [[ " ${pipeline_results[*]} " =~ "running" ]]; then
        echo "GP | color=yellow"
    elif [[ " ${pipeline_results[*]} " =~ "pending" ]]; then
        echo "GP | color=yellow"
    elif [[ " ${pipeline_results[*]} " =~ "failed" ]]; then
        echo "GP | color=red"
    elif [[ " ${pipeline_results[*]} " =~ "-  " ]]; then
        echo "GP | color=red"
    else
        echo "GP | color=lightgreen"
    fi
}

function print_submenu() {
    for pipeline_result in "${pipeline_results[@]}"; do
        project=(${pipeline_result//" - "/ })
        if [[ "$pipeline_result" == *"success"* ]]; then
            echo "$pipeline_result | color=darkgreen href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines"
        elif [[ "$pipeline_result" == *"canceled"* ]]; then
            echo "$pipeline_result | color=slategray href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines"
        elif [[ " $pipeline_result" == *"running"* ]]; then
            echo "$pipeline_result | color=yellow href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines"
        elif [[ " $pipeline_result" == *"pending"* ]]; then
            echo "$pipeline_result | color=yellow href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines"
        else
            echo "$pipeline_result | color=darkred href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines"
        fi
    done
}

get_pipeline_status
print_header
echo "---"
print_submenu
