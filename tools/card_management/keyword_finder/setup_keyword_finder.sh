SCRIPT_DIR="$(dirname "$0")"

if [ -f "$SCRIPT_DIR/../../tools.env" ]; then
    source "$SCRIPT_DIR/../../tools.env"
    DIRECTORY=$CARDS_WORKING_DIR
else
    DIRECTORY=~/IdeaProjects
fi

DIRECTORY=$(echo $DIRECTORY | sed 's/\//\\\//g')

cp help_cm_template.json help_cm.json

sed -i "" "s/\${CARDS_WORKING_DIR}/$DIRECTORY/g" help_cm.json
