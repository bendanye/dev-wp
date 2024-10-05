#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../source.env

vi $WORKING_DIR/list.txt
