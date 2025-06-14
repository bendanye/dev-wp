import csv
import os

from datetime import datetime, timedelta, date

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))


def main() -> None:
    current_date = date.today()

    tasks = _get_tasks(current_date)
    total_break_seconds = _calculate_breaks(tasks)
    minutes = int(total_break_seconds // 60)
    seconds = int(total_break_seconds % 60)

    print(
        f"Estimated break time taken on {current_date}: {minutes} minutes, {seconds} seconds"
    )


def _get_tasks(specified_date):
    if os.path.isfile(f"{SCRIPT_DIR}/tracking_{specified_date}.txt"):
        file_path = f"{SCRIPT_DIR}/tracking_{specified_date}.txt"
    elif os.path.isfile(f"{SCRIPT_DIR}/tracking_h_{specified_date}.txt"):
        file_path = f"{SCRIPT_DIR}/tracking_h_{specified_date}.txt"
    elif os.path.isfile(f"{SCRIPT_DIR}/tracking_e_{specified_date}.txt"):
        file_path = f"{SCRIPT_DIR}/tracking_e_{specified_date}.txt"
    else:
        print(f"There is no time tracking file for {specified_date}")
        exit(0)

    with open(file_path, newline="") as csvfile:
        reader = csv.DictReader(csvfile)
        tasks = []
        for row in reader:
            start_time = datetime.strptime(row["start_date"], "%Y-%m-%d %H:%M:%S")
            desk_minutes = int(row["desk_minutes"])
            tasks.append((start_time, desk_minutes))
        return tasks


def _calculate_breaks(tasks):
    total_break_seconds = 0
    for i in range(1, len(tasks)):
        prev_end = tasks[i - 1][0] + timedelta(minutes=tasks[i - 1][1])
        current_start = tasks[i][0]
        break_duration = (current_start - prev_end).total_seconds()
        if break_duration > 0:
            total_break_seconds += break_duration
    return total_break_seconds


if __name__ == "__main__":
    main()
