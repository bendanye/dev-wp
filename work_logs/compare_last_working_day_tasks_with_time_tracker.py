import os

from datetime import datetime
from date_utils import get_last_working_date, format_date_to_yyyymmdd_hyphen
from read_utils import get_tasks

DIRECTORY = "examples"
TASK_PREFIX = ""

work_log_tasks = set()

last_working_date = get_last_working_date(datetime.now())
tasks = get_tasks(DIRECTORY, last_working_date)

if not tasks:
    while not tasks:
        last_working_date = get_last_working_date(last_working_date)
        tasks = get_tasks(DIRECTORY, last_working_date)

for task in tasks:
    if "- [" in task:
        work_log_tasks.add(
            task.replace("- ", "").replace("[", "").split("]")[0].strip()
        )

time_tracker_file = f"../tools/time_tracker/tracking_{format_date_to_yyyymmdd_hyphen(last_working_date)}.txt"
if not os.path.exists(time_tracker_file):
    time_tracker_file = f"../tools/time_tracker/bkup/tracking_{format_date_to_yyyymmdd_hyphen(last_working_date)}.txt"

time_tracker_tasks = set()
with open(time_tracker_file) as file:
    next(file)
    task_lines = file.readlines()
    for line in task_lines:
        data = line.replace("\n", "").split(",")
        task = data[1]
        if task.startswith(TASK_PREFIX):
            time_tracker_tasks.add(task)


missing = set()
for task in time_tracker_tasks:
    if task.startswith(TASK_PREFIX) and task not in work_log_tasks:
        missing.add(task)

for task in work_log_tasks:
    if task.startswith(TASK_PREFIX) and task not in time_tracker_tasks:
        missing.add(task)


print(missing)
