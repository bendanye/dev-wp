#!/usr/bin/env bash

source source.env

katas=$(jq -c '.katas[]' $SCHEDULE_FILE_NAME)
for kata in $katas; do
    name=$(jq -r '.name' <<< "$kata")
    repo_dir=$(jq -r '.repo_dir' <<< "$kata")
    cd $repo_dir
    if [ -d ".git" ]; then
        echo "Pulling latest commit for $name"
        git pull
    fi
done
