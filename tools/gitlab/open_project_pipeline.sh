#!/usr/bin/env bash

PROJECT=$(basename $(pwd))

set -eu

source ../gitlab.env

open  -a "Google Chrome" "${GITLAB_URL}/${GROUP}/${PROJECT}/~/pipelines"
