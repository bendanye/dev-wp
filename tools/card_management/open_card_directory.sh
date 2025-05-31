#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

source ../tools.env

test "$1"

if [[ "$OSTYPE" == "darwin"* ]]; then
  open "$CARDS_WORKING_DIR/$1"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin"* ]]; then
  explorer "$CARDS_WORKING_DIR/$1"
else
  echo "Unsupported operating system"
fi

