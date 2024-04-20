#!/bin/bash

IFS=$'\n'

TASK=$1

LINES=$(grep -R $TASK .)

print_per_day() {
    loop_date=""
    total_minutes_per_day=0

    for line in ${LINES[@]}; do
        MINUTES=$(echo "$line" | cut -d ',' -f3)
        FILE_NAME=$(echo "$line" | cut -d ':' -f1)
        current_loop_date=$(echo $FILE_NAME | cut -d '_' -f2 | cut -d '.' -f1)
        if [[ $loop_date != $current_loop_date ]]; then
            if [[ $loop_date != "" ]]; then
                echo "$loop_date - $total_minutes_per_day minutes"
            fi
            loop_date=$current_loop_date
            total_minutes_per_day=0
        fi

        total_minutes_per_day=$(( total_minutes_per_day + MINUTES ))
    done

    echo "$loop_date - $total_minutes_per_day minutes"
}

print_total_time_taken() {
    total_minutes=0

    for line in ${LINES[@]}; do
        MINUTES=$(echo "$line" | cut -d ',' -f3)
        total_minutes=$(( total_minutes + MINUTES ))
    done

    HOUR=$(( total_minutes/60 ))
    MINUTE=$(( total_minutes%60 ))
    echo "Total time on $TASK - $HOUR hours $MINUTE minutes"
}


print_per_day
print_total_time_taken