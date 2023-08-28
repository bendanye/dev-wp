#!/usr/bin/env bash

set -eu

test "$1"

source ../jira.env

open  -a "Google Chrome" "${JIRA_URL}/browse/${JIRA_ISSUE_PREFIX}-${1}"
