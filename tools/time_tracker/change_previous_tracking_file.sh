#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/time_tracker_func.sh"

if [[ "$OSTYPE" == "darwin"* ]]; then
  CURRENT_DATE=$(date -v -1d +%Y-%m-%d)
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin"* ]]; then
  CURRENT_DATE=$(date -d "-1 day" "+%Y-%m-%d")
else
  echo "Unsupported operating system"
  exit 1
fi

data_file=$(get_file $CURRENT_DATE)
if ! test -f "$data_file"; then
    echo "There is no tracking file for today"
    exit 1
fi

vi $data_file