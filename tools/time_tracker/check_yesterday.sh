#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/time_tracker_func.sh"

if [ -f "$SCRIPT_DIR/../../dwp.env" ]; then
    source "$SCRIPT_DIR/../../dwp.env"
fi

# Define color codes
RED='\033[0;31m'
RESET='\033[0m'

if [[ "$OSTYPE" == "darwin"* ]]; then
  yesterday=$(date -v -1d +%u)
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin"* ]]; then
  yesterday=$(date -d "-1 day" +%u)
else
  echo "Unsupported operating system"
  exit 1
fi

if [ "$yesterday" -gt 4 ]; then
    echo "Yesterday was not Mon-Thu. Exit"
    exit 0
fi

echo "Yesterday was mon-thurs. Proceed to check"

if [[ "$OSTYPE" == "darwin"* ]]; then
  YESTERDAY_DATE=$(date -v -1d +%Y-%m-%d)
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin"* ]]; then
  YESTERDAY_DATE=$(date -d "-1 day" "+%Y-%m-%d")
else
  echo "Unsupported operating system"
  exit 1
fi

data_file=$(get_file $YESTERDAY_DATE)
if test -f "$data_file"; then
    echo "Found $YESTERDAY_DATE file. No actions needed"
else
    MESSAGE="Missing $YESTERDAY_DATE file. Could be not working or PH. Please proceed to do neccessary action if needed"
    echo -e "${RED}${MESSAGE}${RESET}"
    if [[ $TODO_MAIN_FILE != "" ]]; then
        sh $TODO_MAIN_FILE "$MESSAGE"
    elif [[ $ALERTME_MAIN_FILE != "" ]]; then
        sh $ALERTME_MAIN_FILE -m "$MESSAGE"
    fi
fi
