#!/usr/bin/env bash

export PYTHONWARNINGS="ignore:Unverified HTTPS request"

set -eu

PROJECT=$(basename $(pwd))

BASEDIR=$(dirname "$0")
cd $BASEDIR

source ../../gitlab.env

CONFIG_PATH="$BASEDIR/config.ini"

files=$(find . -name ".gitlab-ci*.yml")

if [[ -z $files ]]; then
    echo "No .gitlab-ci files found"
else
    for file in $files
    do
        echo "Linting $file"
        gitlab --config-file "$CONFIG_PATH" project-ci-lint validate --project-id $GROUP/$PROJECT --content @$file
    done

    echo "All .gitlab-ci files are lint without errors!"
fi

