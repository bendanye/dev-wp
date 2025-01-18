result=$(python3 compare_last_working_day_tasks_with_time_tracker.py)
echo $result
if [[ $result == *"Missing work log tasks"* || $result == *"There is differences between work log and time tracker"* ]]; then
    echo "To add todo"
fi

