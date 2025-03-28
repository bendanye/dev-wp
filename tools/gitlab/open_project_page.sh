#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/../gitlab.env"
source "$SCRIPT_DIR/gitlab.sh"

if [ -z "$1" ]; then
  ACTION="PROJECT"
else
  ACTION=$1
fi


if [ -n "$2" ]; then
    PROJECT=$2
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

if [[ $ACTION == "COMMITS" ]]; then
  SUB_PATH="/-/commits"
elif [[ $ACTION == "COMMITS_BRANCH" ]]; then
  if [[ $FROM == "DIRECTORY" ]]; then
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
    SUB_PATH="/-/commits/${BRANCH_NAME}"
  else
    SUB_PATH="/-/commits"
  fi
elif [[ $ACTION == "PIPELINE" ]]; then
  SUB_PATH="/-/pipelines"
elif [[ $ACTION == "PIPELINE_BRANCH" ]]; then
  if [[ $FROM == "DIRECTORY" ]]; then
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
    SUB_PATH="/-/pipelines?page=1&scope=all&ref=${BRANCH_NAME}"
  else
    SUB_PATH="/-/pipelines"
  fi
elif [[ $ACTION == "BRANCHES" ]]; then
  SUB_PATH="/-/branches"
elif [[ $ACTION == "MR" ]]; then
  SUB_PATH="/-/merge_requests"
elif [[ $ACTION == "MR_BRANCH" ]]; then
  if [[ $FROM == "DIRECTORY" ]]; then
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
    SUB_PATH="/-/merge_requests/?source_branches%5B%5D=${BRANCH_NAME}"
  else
    SUB_PATH="/-/merge_requests"
  fi
elif [[ $ACTION == "MR_ASSIGNED" ]]; then
  SUB_PATH="/-/merge_requests?assignee_username=${GITLAB_GROUP_USER_NAME}"
elif [[ $ACTION == "MR_REVIEWED" ]]; then
  SUB_PATH="/-/merge_requests?reviewer_username=${GITLAB_GROUP_USER_NAME}"
elif [[ $ACTION == "SETTINGS_REPOSITORY" ]]; then
  SUB_PATH="/-/settings/repository"
elif [[ $ACTION == "PROJECT_BRANCH" ]]; then
  if [[ $FROM == "DIRECTORY" ]]; then
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
    SUB_PATH="/-/tree/${BRANCH_NAME}?ref_type=heads"
  else
    SUB_PATH=""
  fi
else
  SUB_PATH=""
fi

open  -a "Google Chrome" "${GITLAB_URL}/${GITLAB_GROUP}/${PROJECT}${SUB_PATH}"
