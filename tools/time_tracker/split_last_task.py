import os

from datetime import timedelta, datetime, date
from typing import List


def main() -> None:
    last_task = _get_last_task_from_file()
    new_entries = _split_minutes(last_task)
    save_to_file(new_entries)
    print("Split task successfully!")


def _get_last_task_from_file() -> str:
    with open(_get_file_path(), "r") as file:
        return file.readlines()[-1].strip()


def save_to_file(new_lines: List[str]) -> None:
    file_path = _get_file_path()
    with open(file_path, "r") as file:
        lines = file.readlines()

    if lines:
        lines[-1:] = [line + "\n" for line in new_lines]

    with open(file_path, "w") as file:
        file.writelines(lines)


def _get_file_path() -> str:
    script_dir = _get_script_dir()
    today = date.today()

    if os.path.isfile(f"{script_dir}/tracking_{today}.txt"):
        file_name = f"{script_dir}/tracking_{today}.txt"
    elif os.path.isfile(f"{script_dir}/tracking_h_{today}.txt"):
        file_name = f"{script_dir}/tracking_h_{today}.txt"
    elif os.path.isfile(f"{script_dir}/tracking_e_{today}.txt"):
        file_name = f"{script_dir}/tracking_e_{today}.txt"

    return file_name


def _get_script_dir():
    return os.path.dirname(os.path.realpath(__file__))


def _split_minutes(entry: str) -> List[str]:
    timestamp, _, minutes = entry.split(",")
    minutes = int(minutes)

    split_values = input(
        f"How do you want to split {minutes} minutes? Enter comma-separated values: "
    )
    split_values = list(map(int, split_values.split(",")))

    if sum(split_values) != minutes:
        print("Error: The split values do not sum up to the original minutes.")
        return

    start_time = datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S")
    new_entries = []

    for value in split_values:
        new_label = input(f"Enter task for {value} minutes: ")
        new_entries.append(
            f"{start_time.strftime('%Y-%m-%d %H:%M:%S')},{new_label},{value}"
        )
        start_time += timedelta(minutes=value)

    return new_entries


if __name__ == "__main__":
    main()
