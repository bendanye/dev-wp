#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../source.env

test "$1"

ID=$1
NEW_DIR="$WORKING_DIR/$ID"

if [[ -d "$NEW_DIR" ]]; then
    echo "$NEW_DIR already exists. Will exit"
    exit 1
fi

mkdir "$NEW_DIR"
echo "Created new folder, $NEW_DIR"

mkdir "$NEW_DIR/$CARD_TEST_EVIDENCES"