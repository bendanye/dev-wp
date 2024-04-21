#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../source.env

test "$1"
ID=$1

cd ~/Desktop
mv *.png "$WORKING_DIR/$ID/$CARD_TEST_EVIDENCES"