#!/usr/bin/env bash

set -eu

PROJECT=$(basename $(pwd))

cd "$(dirname "$0")"

source ../gitlab.env

open  -a "Google Chrome" "${GITLAB_URL}/${GROUP}/${PROJECT}/~/pipelines"
