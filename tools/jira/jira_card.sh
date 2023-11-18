#!/usr/bin/env bash

set -eu

test "$1"

SCRIPT_DIR=$( dirname -- "$0"; )
cd $SCRIPT_DIR

source ../jira.env

open  -a "Google Chrome" "${JIRA_URL}/browse/${JIRA_ISSUE_PREFIX}-${1}"
