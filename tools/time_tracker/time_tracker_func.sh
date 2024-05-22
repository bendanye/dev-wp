SCRIPT_DIR=$( dirname -- "$0"; )

get_exclude_pattern() {
    if [[ $1 == "EXCLUDE_TASKS" ]]; then
        echo "!/(MISC|kata|feedback|conf_talk|learning|PP)/"
    else
        echo ""
    fi
}

get_file() {
    local file="$SCRIPT_DIR/tracking_$1.txt"
    if test -f "$file"; then
        echo $file
    else
        file="$SCRIPT_DIR/tracking_h_$1.txt"
        if test -f "$file"; then
            echo $file
        else
            echo "$1 does not exist!"
        fi
    fi
}