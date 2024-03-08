#!/usr/bin/env bash

set -eu

PROJECT=$(basename `git rev-parse --show-toplevel`)

cd "$(dirname "$0")"
source ../gitlab.env

open -a "Google Chrome" "${GITLAB_URL}/${GROUP}/$PROJECT/-/merge_requests?assignee_username=${USER_NAME}"