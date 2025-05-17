#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../jira.env

URL="${JIRA_URL}/secure/${JIRA_BOARD}"

if [[ "$OSTYPE" == "darwin"* ]]; then
  open -a "Google Chrome" "$URL"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin"* ]]; then
  start "$URL"
else
  echo "Unsupported operating system"
fi