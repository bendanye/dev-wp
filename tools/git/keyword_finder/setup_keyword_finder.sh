SCRIPT_DIR="$(dirname "$0")"

if [ -f "$SCRIPT_DIR/../source.env" ]; then
    source "$SCRIPT_DIR/../source.env"
    DIRECTORY=$GIT_PROJECT_DIR
else
    DIRECTORY=~/IdeaProjects
fi

DIRECTORY=$(echo $DIRECTORY | sed 's/\//\\\//g')

cp help_git_template.json help_git.json

sed -i "" "s/\${GIT_PROJECT_DIR}/$DIRECTORY/g" help_git.json
