SCRIPT_DIR="$(dirname "$0")"

if [ -f "$SCRIPT_DIR/../source.env" ]; then
    source "$SCRIPT_DIR/../source.env"
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