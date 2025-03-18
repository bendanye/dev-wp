#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../tools.env

test "$1"

ID=$1
NEW_DIR="$WORKING_DIR/$ID"

if [[ ! -d "$NEW_DIR" ]]; then
    mkdir "$NEW_DIR"
    echo "Created new folder, $NEW_DIR"
fi

mkdir "$NEW_DIR/$CARD_TEST_EVIDENCES"
