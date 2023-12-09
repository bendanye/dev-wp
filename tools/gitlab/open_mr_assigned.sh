#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../gitlab.env

open  -a "Google Chrome" "${GITLAB_URL}/dashboard/merge_requests?assignee_username=${USER_NAME}"
