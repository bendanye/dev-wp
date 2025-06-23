import os

from datetime import timedelta, datetime, date
from typing import List


def main() -> None:
    last_task = _get_last_task_from_file()
    new_entries = _subtract_minutes(last_task)
    save_to_file(new_entries)
    print("Change last Task's minutes successfully!")


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


def _subtract_minutes(entry: str) -> List[str]:
    timestamp, task, minutes = entry.split(",")
    minutes = int(minutes)

    subtract_minutes = int(
        input(f"What is the number of minutes to subtract? Original is {minutes}: ")
    )

    if subtract_minutes > minutes:
        print("Error: The subtract value is more than Original minutes.")
        return

    start_time = datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S")
    new_entries = []
    new_entries.append(
        f"{start_time.strftime('%Y-%m-%d %H:%M:%S')},{task},{minutes - subtract_minutes}"
    )

    return new_entries


if __name__ == "__main__":
    main()
