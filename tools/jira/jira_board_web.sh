#!/usr/bin/env bash

set -eu

SCRIPT_DIR=$( dirname -- "$0"; )
cd $SCRIPT_DIR

source ../jira.env

open  -a "Google Chrome" "${JIRA_URL}/secure/${JIRA_BOARD}"