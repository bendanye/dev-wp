#!/bin/bash

SCRIPT_PATH=$(pwd)

echo "Setup tools"

read -p "Name of the project: " project_name
read -p "Communication (google, slack, telegram, discord): " communication
read -p "Name of the type of managment (default is cards): " management

echo

if [[ $management == "" ]]; then
    management="cards"
fi

GIT_PROJECT_DIR="$HOME/IdeaProjects/$project_name"

cd "$SCRIPT_PATH/../"

mkdir -p "$project_name/$management"

cd "$project_name"
project_dir=$(pwd)

cd "$management"
cards_dir=$(pwd)

echo "PROJECT_WORKING_DIR=\"$project_dir\"" > "$SCRIPT_PATH/tools.env"
echo "CARDS_WORKING_DIR=\"$cards_dir\"" > "$SCRIPT_PATH/tools.env"
echo "CARD_TEST_EVIDENCES=\"test_evidences\"" >> "$SCRIPT_PATH/tools.env"
echo "COMMUNICATION=(\"$communication\")" >> "$SCRIPT_PATH/tools.env"
echo "GIT_PROJECT_DIR=\"$GIT_PROJECT_DIR\"" >> "$SCRIPT_PATH/tools.env"

touch $project_dir/list.txt

echo "Setup Keyword Finder"
KEYWORD_FINDER_PROJECTS=("alias" "card_management" "git" "time_tracker")

for project in ${KEYWORD_FINDER_PROJECTS[@]}; do
    cd $SCRIPT_PATH/$project/keyword_finder
    sh setup_keyword_finder.sh
done

echo "Setup completed"
