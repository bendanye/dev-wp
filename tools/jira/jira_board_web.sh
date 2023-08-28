#!/usr/bin/env bash

set -eu

source ../jira.env

open  -a "Google Chrome" "${JIRA_URL}/secure/${JIRA_BOARD}"