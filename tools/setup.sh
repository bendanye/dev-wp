#!/bin/bash

read -p "Your project working directory: " project_dir_var
echo

echo "WORKING_DIR=\"$project_dir_var\"" > source.env
echo "CARD_TEST_EVIDENCES=\"test_evidences\"" >> source.env

echo "Setup completed"