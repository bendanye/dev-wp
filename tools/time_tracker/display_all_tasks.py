from datetime import timedelta, date

import glob
import os
import sys
from typing import List

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
    all_backup_files = _get_backup_files()
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


def _get_backup_files():
    return glob.glob(f"{SCRIPT_DIR}/bkup/tracking_*.txt")


def _get_card_management_list() -> List[str]:
    source_env = f"{SCRIPT_DIR}/../tools.env"
    if not os.path.exists(source_env):
        return []

    with open(source_env, "r") as source_env_file:
        for line in source_env_file.readlines():
            if "CARDS_WORKING_DIR" in line:
                proj_path = (
                    line.replace("CARDS_WORKING_DIR=", "").replace('"', "").strip()
                )
                card_management = f"{proj_path}/list.txt"
                if not os.path.exists(card_management):
                    return []

                with open(card_management, "r") as card_management_file:
                    return [entry.strip() for entry in card_management_file.readlines()]

    return []


def _get_card_name(task: str, card_management_list: List[str]) -> str:
    if not card_management_list:
        return task

    for card_name in card_management_list:
        if task in card_name.split(":")[0]:
            return card_name

    return task


get_backup_tasks_by = "LAST_WEEK"
is_header_display = True

if len(sys.argv) > 1:
    is_header_display = False
    if sys.argv[1] == "ALL":
        get_backup_tasks_by = "ALL"

files = glob.glob(f"{SCRIPT_DIR}/tracking_*.txt")
this_week_tasks = get_tasks(files, set())

card_management_list = _get_card_management_list()

if is_header_display:
    print("This week's tasks that were focused on:")

for task in sorted(this_week_tasks):
    name = _get_card_name(task, card_management_list)
    print(name)


files = (
    _get_last_week_files()
    if get_backup_tasks_by == "LAST_WEEK"
    else _get_backup_files()
)
remaining_tasks = get_tasks(files, this_week_tasks)

if is_header_display and get_backup_tasks_by == "LAST_WEEK":
    print("\nLast week's tasks that were focused on (not on this week):")

for task in sorted(remaining_tasks):
    name = _get_card_name(task, card_management_list)
    print(name)
