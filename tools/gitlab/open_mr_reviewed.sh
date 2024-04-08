#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../gitlab.env

open  -a "Google Chrome" "${GITLAB_URL}/dashboard/merge_requests?reviewer_username=${GITLAB_GROUP_USER_NAME}"
