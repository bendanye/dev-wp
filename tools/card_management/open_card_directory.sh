#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../tools.env

test "$1"

open "$CARDS_WORKING_DIR/$1"