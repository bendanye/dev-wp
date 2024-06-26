from datetime import timedelta, date

import os.path
import math
from typing import Dict


def group_by_task(file_name: str, tasks: Dict[str, int]):
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


def print_breakdown(tasks: Dict[str, int]):
    print(f"Breakdown of tasks from {start} to {current_date}")
    print("--------------")
    sort_by_longest_task = dict(
        sorted(tasks.items(), key=lambda item: item[1], reverse=True)
    )
    for task, minutes in sort_by_longest_task.items():
        if minutes < 60:
            print(f"{task} - {minutes} minutes")
        else:
            hour = math.floor(minutes / 60)
            remaining_minutes = minutes % 60
            print(f"{task} - {hour} hours {remaining_minutes} minutes")


current_date = date.today()
start = current_date - timedelta(days=current_date.weekday())
tasks = {}

loop_date = start
while loop_date <= current_date:
    if os.path.isfile(f"tracking_{loop_date}.txt"):
        group_by_task(f"tracking_{loop_date}.txt", tasks)
    elif os.path.isfile(f"tracking_h_{loop_date}.txt"):
        group_by_task(f"tracking_h_{loop_date}.txt", tasks)
    elif os.path.isfile(f"tracking_e_{loop_date}.txt"):
        group_by_task(f"tracking_e_{loop_date}.txt", tasks)

    loop_date = loop_date + timedelta(days=1)

print_breakdown(tasks)
