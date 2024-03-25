#!/usr/bin/env bash

cd "$(dirname "$0")"

source source.env

kata_found="false"

day_of_week=$(date +%w)
days=("Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday")
day_of_week=${days[$day_of_week]}

katas=$(jq -c '.katas[]' schedule.json)
for kata in $katas; do
    name=$(jq -r '.name' <<< "$kata")
    day=$(jq -r '.["day-of-week"]' <<< "$kata")

    if [[ $day == $day_of_week ]]; then
        kata_found="true"
        echo "There is planned kata, '$name' on $day_of_week"
    fi
done

if [[ $kata_found == "false" ]]; then
    echo "There is no kata planned on $day_of_week"
fi