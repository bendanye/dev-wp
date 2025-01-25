#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../tools.env

vi $WORKING_DIR/list.txt
