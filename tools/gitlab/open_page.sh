#!/usr/bin/env bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/../gitlab.env"

if [ -z "$1" ]; then
  ACTION="HOMEPAGE"
else
  ACTION=$1
fi

if [[ $ACTION == "MR_ASSIGNED" ]]; then
  SUB_PATH="/dashboard/merge_requests?assignee_username=${GITLAB_GROUP_USER_NAME}"
elif [[ $ACTION == "MR_REVIEWED" ]]; then
  SUB_PATH="/dashboard/merge_requests?reviewer_username=${GITLAB_GROUP_USER_NAME}"
else
  SUB_PATH=""
fi

URL="${GITLAB_URL}${SUB_PATH}"

if [[ "$OSTYPE" == "darwin"* ]]; then
  open -a "Google Chrome" "$URL"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin"* ]]; then
  start "$URL"
else
  echo "Unsupported operating system"
fi