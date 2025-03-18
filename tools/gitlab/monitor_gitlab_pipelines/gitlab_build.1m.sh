#!/usr/bin/env bash

#<xbar.title>Monitor Gitlab Builds</xbar.title>
#<xbar.author>Benjamin Ng</xbar.author>
#<xbar.dependencies>jq</xbar.dependencies>
#<xbar.var>string(VAR_PROJECT_NAME=""): Project name to view in different branch.</xbar.var>
#<xbar.var>string(VAR_BRANCH_NAME=""): Branch name to view.</xbar.var>

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
        if [[ $VAR_PROJECT_NAME == $project ]]; then
            result=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "${GITLAB_URL}/api/v4/projects/${GITLAB_GROUP_ENCODING}${project}/pipelines/latest?ref=${VAR_BRANCH_NAME}")
        else
            result=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "${GITLAB_URL}/api/v4/projects/${GITLAB_GROUP_ENCODING}${project}/pipelines/latest")
        fi
        status=$(echo $result | /opt/homebrew/bin/jq -r '.status')
        id=$(echo $result | /opt/homebrew/bin/jq -r '.id')
        pipeline_results+=("$project - $status - $id")
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

        branch_name=""
        if [[ $VAR_PROJECT_NAME == $project ]]; then
            branch_name="(${VAR_BRANCH_NAME})"
        fi
        
        id=(${pipeline_result##*- })
        if [[ "$pipeline_result" == *"success"* ]]; then
            echo "$pipeline_result $branch_name | color=darkgreen href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines/$id"
        elif [[ "$pipeline_result" == *"manual"* ]]; then
            echo "$pipeline_result $branch_name | color=darkgreen href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines/$id"
        elif [[ "$pipeline_result" == *"canceled"* ]]; then
            echo "$pipeline_result $branch_name | color=slategray href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines/$id"
        elif [[ "$pipeline_result" == *"skipped"* ]]; then
            echo "$pipeline_result $branch_name | color=slategray href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines/$id"
        elif [[ " $pipeline_result" == *"running"* ]]; then
            echo "$pipeline_result $branch_name | color=yellow href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines/$id"
        elif [[ " $pipeline_result" == *"pending"* ]]; then
            echo "$pipeline_result $branch_name | color=yellow href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines/$id"
        else
            echo "$pipeline_result $branch_name | color=darkred href=$GITLAB_URL/$GITLAB_GROUP/$project/-/pipelines/$id"
        fi
    done
}

get_pipeline_status
print_header
echo "---"
print_submenu
