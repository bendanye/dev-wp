import os
import sys
import re


def main(task: str) -> None:
    script_dir = os.path.dirname(os.path.realpath(__file__))
    os.chdir(script_dir)

    records = _get_records(task=task)
    records.sort()

    _print_per_day(records)
    _print_total_time_taken(task=task, records=records)


def _get_records(task: str):
    records = []

    for root, _, files in os.walk("."):
        for file in files:
            file_path = os.path.join(root, file)
            try:
                with open(file_path, "r") as f:
                    for line in f:
                        if f",{task}," in line:
                            records.append((file_path, line.strip()))
            except (OSError, UnicodeDecodeError):
                pass

    return records


def _print_per_day(records) -> None:
    loop_date = ""
    total_minutes_per_day = 0

    for file_name, line in records:
        try:
            minutes = int(re.split(r",", line)[2])
        except (IndexError, ValueError):
            continue

        if "tracking_h_" in file_name:
            current_loop_date = re.search(r"tracking_h_([^_]+)\.", file_name).group(1)
        else:
            current_loop_date = re.search(r"_([^_]+)\.", file_name).group(1)

        if loop_date != current_loop_date:
            if loop_date:
                print(f"{loop_date} - {total_minutes_per_day} minutes")
            loop_date = current_loop_date
            total_minutes_per_day = 0

        total_minutes_per_day += minutes

    if loop_date:
        print(f"{loop_date} - {total_minutes_per_day} minutes")


def _print_total_time_taken(task: str, records) -> None:
    total_minutes = 0

    for _, line in records:
        try:
            minutes = int(re.split(r",", line)[2])
            total_minutes += minutes
        except (IndexError, ValueError):
            continue

    hours = total_minutes // 60
    minutes = total_minutes % 60
    print(f"Total time on {task} - {hours} hours {minutes} minutes")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please enter the task name to check")
        sys.exit(0)

    main(task=sys.argv[1])
