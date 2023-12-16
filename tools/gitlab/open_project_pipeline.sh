#!/usr/bin/env bash

if [ -n "$1" ]; then
    PROJECT=$1
else
    PROJECT=$(basename $(pwd))
fi

cd "$(dirname "$0")"

source ../gitlab.env

open  -a "Google Chrome" "${GITLAB_URL}/${GROUP}/${PROJECT}/~/pipelines"
