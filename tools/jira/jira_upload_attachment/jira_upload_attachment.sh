#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../../tools.env

ID=$1

if [[ "$2" == "" ]]; then
    ATTACHMENT="$CARD_TEST_EVIDENCES.zip"
else
    ATTACHMENT=$2
fi

python3 jira_upload_attachment.py "$ID" "$ATTACHMENT"