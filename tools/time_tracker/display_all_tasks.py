from datetime import timedelta, date

import glob
import os
import sys

SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))


def get_tasks(files, exclude_tasks):
    result = set()

    for file_name in files:
        with open(file_name, "r") as file:
            next(file)
            lines = file.readlines()
            for line in lines:
                data = line.replace("\n", "").split(",")
                task = data[1]
                if task not in exclude_tasks and task != "MISC":
                    result.add(task)

    return result


def _get_last_week_files():
    all_backup_files = glob.glob(f"{SCRIPT_DIR}/bkup/tracking_*.txt")
    files = []

    current_date = date.today()
    start_date = current_date + timedelta(-current_date.weekday(), weeks=-1)
    end_date = current_date + timedelta(-current_date.weekday() - 1)
    loop_date = start_date
    while loop_date <= end_date:
        for file in all_backup_files:
            if str(loop_date) in file:
                files.append(file)
                break

        loop_date = loop_date + timedelta(days=1)

    return files


is_header_display = True if len(sys.argv) == 1 else False


files = glob.glob(f"{SCRIPT_DIR}/tracking_*.txt")
this_week_tasks = get_tasks(files, set())

if is_header_display:
    print("This week's tasks that were focused on:")

for task in sorted(this_week_tasks):
    print(task)


files = _get_last_week_files()
remaining_tasks = get_tasks(files, this_week_tasks)

if is_header_display:
    print("\nLast week's tasks that were focused on (not on this week):")

for task in sorted(remaining_tasks):
    print(task)
