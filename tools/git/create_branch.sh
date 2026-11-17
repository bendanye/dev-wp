#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <branch name>"
  exit 1
fi

git switch -c $1
git push -u origin $1