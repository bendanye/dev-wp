SCRIPT_DIR=$( dirname -- "$0"; )

source "$SCRIPT_DIR/../gitlab.env"

get_group_name() {
    if [[ $GITLAB_GROUP == "" ]]; then
        PROJECT=$1
        FROM=$2
        if [ "$FROM" == "TERMINAL" ]; then
            if [ -f "$SCRIPT_DIR/../source.env" ]; then
                source "$SCRIPT_DIR/../source.env"
            elif [[ $GITLAB_GROUP == "" ]]; then
                echo "source.env missing and GITLAB_GROUP is empty. Unable to determine the project url"
            fi

            
            if [[ -d "$GIT_PROJECT_DIR/$PROJECT" ]]; then
                cd "$GIT_PROJECT_DIR/$PROJECT"
            elif [[ $GITLAB_GROUP == "" ]]; then
                echo "$PROJECT does not exists in $GIT_PROJECT_DIR and GITLAB_GROUP is empty. Unable to determine the project url"
            fi
        fi

        URL=$(git config --get remote.origin.url)
        if [[ $URL != https* ]]; then
            GITLAB_GROUP=${URL#*:}
            GITLAB_GROUP=${GITLAB_GROUP%/*}
            echo $GITLAB_GROUP
        fi
    else
        echo $GITLAB_GROUP
    fi
}