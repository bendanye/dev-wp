#!/usr/bin/env bash

cd "$(dirname "$0")"

source source.env

test $REPO_DIR

SHORTCUT_KATA_DIRECTORY="$REPO_DIR/shortcut-kata"
COMMAND_KATA_DIRECTORY="$REPO_DIR/command-kata"
JAVA_8_CODE_KATA_DIRECTORY="$REPO_DIR/java8-code-kata"


if [[ $1 ]]; then
    specified_date=$1
else
    specified_date=$(date '+%Y-%m-%d')
fi

function check() {
    local dir=$1
    if [[ ! -f "$dir/time_taken.txt" ]]; then
        echo -e "[ ] $dir"
    else
        result=$(cat $dir/time_taken.txt | grep $specified_date)
        if [[ $result ]]; then
            secs=${result##*,}
            echo -e "[\xE2\x9C\x94] $dir - $secs"
        else
            echo -e "[ ] $dir"
        fi
    fi
 }
 
 function time_taken() {
    local dir=$1
    if [[ -f "$dir/time_taken.txt" ]]; then
        result=$(cat $dir/time_taken.txt | grep $specified_date)
        if [[ $result ]]; then
            secs=${result##*,}
            echo $secs
        fi
    fi
 }

function print_each_summary() {
    for dir in $SHORTCUT_KATA_DIRECTORY/*/ ; do
        check $dir
    done

    check $COMMAND_KATA_DIRECTORY
    check $JAVA_8_CODE_KATA_DIRECTORY
}

function print_total_secs() {
    total_secs=0
    for dir in $SHORTCUT_KATA_DIRECTORY/*/ ; do
        secs=$(time_taken $dir)
        total_secs=$((total_secs + secs))
    done

    secs=$(time_taken $COMMAND_KATA_DIRECTORY)
    total_secs=$((total_secs + secs))

    secs=$(time_taken $JAVA_8_CODE_KATA_DIRECTORY)
    total_secs=$((total_secs + secs))

    echo "Total time taken: $total_secs secs"
}

print_each_summary
print_total_secs