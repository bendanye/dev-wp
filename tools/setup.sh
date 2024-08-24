#!/bin/bash

SCRIPT_PATH=$(pwd)

read -p "Name of the project: " project_name
read -p "Communication (google, slack): " communication
read -p "Name of the type of managment (default is cards): " management

echo

if [[ $management == "" ]]; then
    management="cards"
fi

GIT_PROJECT_DIR="$HOME/IdeaProjects/$project_name"

cd "$SCRIPT_PATH/../"

mkdir -p "$project_name/$management"

cd "$project_name/$management"

project_dir=$(pwd)

echo "WORKING_DIR=\"$project_dir\"" > "$SCRIPT_PATH/source.env"
echo "CARD_TEST_EVIDENCES=\"test_evidences\"" >> "$SCRIPT_PATH/source.env"
echo "COMMUNICATION=(\"$communication\")" >> "$SCRIPT_PATH/source.env"
echo "GIT_PROJECT_DIR=\"$GIT_PROJECT_DIR\"" >> "$SCRIPT_PATH/source.env"

touch $project_dir/list.txt

echo "Setup completed"
