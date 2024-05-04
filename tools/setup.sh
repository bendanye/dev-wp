#!/bin/bash

SCRIPT_PATH=$(pwd)

read -p "Name of the project: " project_name
read -p "Communication (google, slack): " communication

echo

cd "$SCRIPT_PATH/../"

mkdir -p "$project_name/cards"

cd "$project_name/cards"

project_dir=$(pwd)

echo "WORKING_DIR=\"$project_dir\"" > "$SCRIPT_PATH/source.env"
echo "CARD_TEST_EVIDENCES=\"test_evidences\"" >> "$SCRIPT_PATH/source.env"
echo "COMMUNICATION=\"$communication\"" >> "$SCRIPT_PATH/source.env"

echo "Setup completed"
