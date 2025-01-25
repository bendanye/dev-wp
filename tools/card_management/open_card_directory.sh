#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../tools.env

test "$1"

open "$WORKING_DIR/$1"