#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../tools.env

vi $CARDS_WORKING_DIR/list.txt
