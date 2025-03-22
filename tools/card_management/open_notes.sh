#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../tools.env

test "$1"

ID=$1
CARD_DIR="$CARDS_WORKING_DIR/$ID"

if [[ ! -d "$CARD_DIR" ]]; then
    mkdir "$CARD_DIR"
    echo "Created new folder, $CARD_DIR"
fi

vi "$CARD_DIR/notes"
