#!/usr/bin/env bash

set -eu

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/../gitlab.env"

open  -a "Google Chrome" "${GITLAB_URL}/dashboard/merge_requests?reviewer_username=${GITLAB_GROUP_USER_NAME}"
