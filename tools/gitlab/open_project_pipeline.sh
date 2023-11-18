#!/usr/bin/env bash

set -eu

PROJECT=$(basename $(pwd))

SCRIPT_DIR=$( dirname -- "$0"; )
cd $SCRIPT_DIR

source ../gitlab.env

open  -a "Google Chrome" "${GITLAB_URL}/${GROUP}/${PROJECT}/~/pipelines"
