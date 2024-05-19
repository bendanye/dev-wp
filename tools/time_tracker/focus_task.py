from datetime import timedelta, date

import os.path
import math
from typing import Dict

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
    else:
        file_name = f"{SCRIPT_DIR}/tracking_h_{specified_date}.txt"
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
    for task, minutes in sort_by_longest_task.items():
        if minutes < 60:
            if print_in_terminal:
                print(f"{task} - {minutes} minutes")
            else:
                print(f"-- {task} - {minutes} minutes")
        else:
            hour = math.floor(minutes / 60)
            remaining_minutes = minutes % 60
            if print_in_terminal:
                print(f"{task} - {hour} hours {remaining_minutes} minutes")
            else:
                print(f"-- {task} - {hour} hours {remaining_minutes} minutes")


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
