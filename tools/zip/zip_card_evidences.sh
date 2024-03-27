#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../source.env

test "$1"
ID=$1

NEW_DIR="$WORKING_DIR/$ID"

cd $NEW_DIR
zip -r $CARD_WORKING_DIR.zip $CARD_WORKING_DIR