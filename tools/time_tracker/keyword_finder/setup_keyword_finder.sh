DIRECTORY=$(echo $PWD/.. | sed 's/\//\\\//g')

cp help_time_tracker_template.json help_time_tracker.json

sed -i "" "s/\${PROJECT_DIR}/$DIRECTORY/g" help_time_tracker.json
