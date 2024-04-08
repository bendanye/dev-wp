#!/usr/bin/env bash

set -eu

PROJECT=$(basename `git rev-parse --show-toplevel`)

cd "$(dirname "$0")"
source ../gitlab.env

open -a "Google Chrome" "${GITLAB_URL}/${GITLAB_GROUP}/$PROJECT/-/merge_requests?reviewer_username=${GITLAB_GROUP_USER_NAME}"