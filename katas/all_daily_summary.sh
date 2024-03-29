#!/usr/bin/env bash

cd "$(dirname "$0")"

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
    katas=$(jq -c '.katas[]' schedule.json)
    for kata in $katas; do
        name=$(jq -r '.name' <<< "$kata")
        kata_directory=$(jq -r '.repo_dir' <<< "$kata")
        multiple_kata=$(jq -r '.["contains-multiple-kata"]' <<< "$kata")
        if [[ $multiple_kata == "true" ]]; then
            for dir in $kata_directory/*/ ; do
                check $dir
            done
        else
            check $kata_directory
        fi
    done

    
}

function print_total_secs() {
    total_secs=0

    katas=$(jq -c '.katas[]' schedule.json)
    for kata in $katas; do
        name=$(jq -r '.name' <<< "$kata")
        kata_directory=$(jq -r '.repo_dir' <<< "$kata")
        multiple_kata=$(jq -r '.["contains-multiple-kata"]' <<< "$kata")
        if [[ $multiple_kata == "true" ]]; then
            for dir in $kata_directory/*/ ; do
                secs=$(time_taken $dir)
                total_secs=$((total_secs + secs))
            done
        else
            secs=$(time_taken $kata_directory)
            total_secs=$((total_secs + secs))
        fi
    done

    echo "Total time taken: $total_secs secs"
}

print_each_summary
print_total_secs