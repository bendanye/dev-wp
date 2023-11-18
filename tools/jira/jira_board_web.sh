#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../jira.env

open  -a "Google Chrome" "${JIRA_URL}/secure/${JIRA_BOARD}"