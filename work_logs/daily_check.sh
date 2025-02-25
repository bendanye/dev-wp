#!/bin/bash

SCRIPT_DIR=$( dirname -- "$0"; )

if [ -f "$SCRIPT_DIR/../dwp.env" ]; then
    source "$SCRIPT_DIR/../dwp.env"
fi

result=$(python3 compare_last_working_day_tasks_with_time_tracker.py)
echo $result
if [[ $result == *"Missing work log tasks"* || $result == *"There is differences between work log and time tracker"* ]]; then
  MESSAGE=$result
  if [[ $TODO_MAIN_FILE != "" ]]; then
    sh "${TODO_MAIN_FILE}" "$MESSAGE"
  elif [[ $ALERTME_MAIN_FILE != "" ]]; then
    sh $ALERTME_MAIN_FILE -m "$MESSAGE"
  fi
fi

result=$(python3 check_specified_tasks.py)
echo $result
if [[ $result == *"is found in last working day"* ]]; then
  MESSAGE=$result
  if [[ $TODO_MAIN_FILE != "" ]]; then
    sh "${TODO_MAIN_FILE}" "$MESSAGE"
  elif [[ $ALERTME_MAIN_FILE != "" ]]; then
    sh $ALERTME_MAIN_FILE -m "$MESSAGE"
  fi
fi

result=$(python3 read_last_working_day_goals.py)
echo $result
if [[ $result == *"There is goals set for"* ]]; then
  MESSAGE=$result
  if [[ $TODO_MAIN_FILE != "" ]]; then
    sh "${TODO_MAIN_FILE}" "$MESSAGE"
  elif [[ $ALERTME_MAIN_FILE != "" ]]; then
    sh $ALERTME_MAIN_FILE -m "$MESSAGE"
  fi
fi