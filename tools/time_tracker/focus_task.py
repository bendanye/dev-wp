from datetime import timedelta, date

import os.path
import math
from typing import Dict, List

import sys

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))


def day_focus():
    tasks = {}
    current_date = date.today()

    focus(current_date, tasks)

    if print_in_terminal:
        print("--------------")
        print(f"Focused tasks for {current_date}")
    print_focus(tasks)


def week_focus():
    tasks = {}
    current_date = date.today()
    start = current_date - timedelta(days=current_date.weekday())

    loop_date = start
    while loop_date <= current_date:
        focus(loop_date, tasks)
        loop_date = loop_date + timedelta(days=1)

    if print_in_terminal:
        print("--------------")
        print(f"Focused tasks from {start} to {current_date}")
    print_focus(tasks)


def focus(specified_date, tasks):
    file_name = f"{SCRIPT_DIR}/tracking_{specified_date}.txt"
    if os.path.isfile(file_name):
        _group_by_task(file_name, tasks)
    elif os.path.isfile(f"{SCRIPT_DIR}/tracking_h_{specified_date}.txt"):
        file_name = f"{SCRIPT_DIR}/tracking_h_{specified_date}.txt"
        _group_by_task(file_name, tasks)
    elif os.path.isfile(f"{SCRIPT_DIR}/tracking_e_{specified_date}.txt"):
        file_name = f"{SCRIPT_DIR}/tracking_e_{specified_date}.txt"
        _group_by_task(file_name, tasks)


def _group_by_task(file_name: str, tasks: Dict[str, int]):
    if not os.path.isfile(file_name):
        return

    with open(file_name, "r") as file:
        next(file)
        lines = file.readlines()
        for line in lines:
            data = line.replace("\n", "").split(",")
            minutes = tasks.get(data[1])
            if minutes is None:
                minutes = 0

            tasks[data[1]] = minutes + int(data[2])


def print_focus(tasks: Dict[str, int]):
    if print_in_terminal:
        print("--------------")

    sort_by_longest_task = dict(
        sorted(tasks.items(), key=lambda item: item[1], reverse=True)
    )

    card_management_list = _get_card_management_list()

    for task, minutes in sort_by_longest_task.items():

        name = _get_card_name(task, card_management_list)

        if minutes < 60:
            if print_in_terminal:
                print(f"{name} - {minutes} minutes")
            else:
                print(f"-- {name} - {minutes} minutes")
        else:
            hour = math.floor(minutes / 60)
            remaining_minutes = minutes % 60
            if print_in_terminal:
                print(f"{name} - {hour} hours {remaining_minutes} minutes")
            else:
                print(f"-- {name} - {hour} hours {remaining_minutes} minutes")


def _get_card_management_list() -> List[str]:
    source_env = f"{SCRIPT_DIR}/../source.env"
    if not os.path.exists(source_env):
        return []

    with open(source_env, "r") as source_env_file:
        for line in source_env_file.readlines():
            if "WORKING_DIR" in line:
                proj_path = line.replace("WORKING_DIR=", "").replace('"', "").strip()
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
        if task in card_name:
            return card_name

    return task


if len(sys.argv) < 2:
    raise ValueError("Expected at least one argument, d or w")

if len(sys.argv) == 3:
    print_in_terminal = False
else:
    print_in_terminal = True

type = sys.argv[1]
if type == "d":
    day_focus()
elif type == "w":
    week_focus()
else:
    raise ValueError(f"Unknown parameter pass: {type}")
