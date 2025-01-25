SCRIPT_DIR="$(dirname "$0")"

if [ -f "$SCRIPT_DIR/../tools.env" ]; then
    source "$SCRIPT_DIR/../tools.env"
    DIRECTORY=$GIT_PROJECT_DIR
else
    DIRECTORY=~/IdeaProjects
fi

if [[ $1 ]]; then
    cd $DIRECTORY/$1
else
    cd $DIRECTORY
fi

code .