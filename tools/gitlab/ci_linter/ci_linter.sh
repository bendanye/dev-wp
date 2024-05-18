#!/usr/bin/env bash

export PYTHONWARNINGS="ignore:Unverified HTTPS request"

if [ -n "$1" ]; then
    PROJECT=$1
    FROM="TERMINAL"
else
    PROJECT=$(basename `git rev-parse --show-toplevel`)
    FROM="DIRECTORY"
fi

BASEDIR=$(dirname "$0")

source "$BASEDIR/../../gitlab.env"
source "$BASEDIR/../gitlab.sh"

GITLAB_GROUP=$(get_group_name $PROJECT $FROM)

if [[ $GITLAB_GROUP == *"Unable to determine the project url"* ]]; then
    echo $GITLAB_GROUP
    exit 1
fi 

CONFIG_PATH="$BASEDIR/config.ini"

files=$(find . -name ".gitlab-ci*.yml")

if [[ -z $files ]]; then
    echo "No .gitlab-ci files found"
else
    for file in $files
    do
        echo "Linting $file"
        gitlab --config-file "$CONFIG_PATH" project-ci-lint validate --project-id $GITLAB_GROUP/$PROJECT --content @$file
    done

    echo "All .gitlab-ci files are lint without errors!"
fi

