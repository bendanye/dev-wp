DIRECTORY=$(pwd)

DIRECTORY=$(echo $DIRECTORY | sed 's/\//\\\//g')

cp help_alias_template.json help_alias.json

sed -i "" "s/\${WORKING_DIR}/$DIRECTORY/g" help_alias.json
