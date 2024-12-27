SCRIPT_DIR=$( dirname -- "$0"; )

SUMMARY_EXCLUDE_PATTERN="!/(MISC|kata|feedback|PP|admin)/"
SUMMARY_ACTION_ALL_TASKS="ALL_TASKS"
SUMMARY_ACTION_EXCLUDE_TASKS="EXCLUDE_TASKS"

# currently place here the default action
get_default_show_task() {
    echo $SUMMARY_ACTION_ALL_TASKS
}

get_exclude_pattern() {
    if [[ $1 == $SUMMARY_ACTION_EXCLUDE_TASKS ]]; then
        echo $SUMMARY_EXCLUDE_PATTERN
    elif [[ $1 == $SUMMARY_ACTION_ALL_TASKS ]]; then
        echo ""
    else
        local default=$(get_default_show_task)
        if [[ $default == $SUMMARY_ACTION_EXCLUDE_TASKS ]]; then
            echo $SUMMARY_EXCLUDE_PATTERN
        else
            echo ""
        fi
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
