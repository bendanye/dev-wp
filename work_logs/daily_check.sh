#!/bin/bash

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

