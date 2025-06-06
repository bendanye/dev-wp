SCRIPT_DIR="$(dirname "$0")"

if [ -f "$SCRIPT_DIR/../../../dwp.env" ]; then
    source "$SCRIPT_DIR/../../../dwp.env"
fi

if [[ $KEYWORD_FINDER_MAIN_FILE == "" ]]; then
    echo "Please specify the path and the file where keyword-finder project located"
    exit 0
fi

if [[ $1 == "" ]]; then
    echo "Please specify the command"
    exit 0
fi

sh $KEYWORD_FINDER_MAIN_FILE "$SCRIPT_DIR/help_git.json" $1 $2