#!/usr/bin/env bash

set -eu

PROJECT=$(basename $(pwd))

source ../gitlab.env

open  -a "Google Chrome" "${GITLAB_URL}/${GROUP}/${PROJECT}"
