#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../tools.env

test "$1"

vi "$WORKING_DIR/$1/notes"