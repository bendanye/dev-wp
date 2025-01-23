import os

from datetime import datetime
from date_utils import get_last_working_date, format_date_to_yyyymmdd_hyphen
from read_utils import get_tasks

DIRECTORY = "logs"
TASK_PREFIX = ""


def main() -> None:
    last_working_date = _get_last_working_date_exists()
    work_log_tasks = _get_tasks_from_work_log(last_working_date)
    time_tracker_tasks = _get_tasks_from_time_tracker(last_working_date)

    print(f"last working date: {format_date_to_yyyymmdd_hyphen(last_working_date)}")
    if work_log_tasks and not time_tracker_tasks:
        print("\033[91mMissing time tracker tasks")
    elif not work_log_tasks and time_tracker_tasks:
        print("\033[91mMissing work log tasks")
    else:
        missing = set()
        for task in time_tracker_tasks:
            if task.startswith(TASK_PREFIX) and task not in work_log_tasks:
                missing.add(task)

        for task in work_log_tasks:
            if task.startswith(TASK_PREFIX) and task not in time_tracker_tasks:
                missing.add(task)

        if not missing:
            print("No differences between work log and time tracker")
        else:
            print("\033[91mThere is differences between work log and time tracker")
            print(missing)


def _get_last_working_date_exists():
    last_working_date = get_last_working_date(datetime.now())
    while True:
        work_log_tasks = get_tasks(DIRECTORY, last_working_date)
        time_tracker_tasks = _get_tasks_from_time_tracker(last_working_date)

        if not work_log_tasks and not time_tracker_tasks:
            last_working_date = get_last_working_date(last_working_date)
        else:
            break

    return last_working_date


def _get_tasks_from_work_log(last_working_date):
    work_log_tasks = set()

    last_working_date = _get_last_working_date_exists()
    tasks = get_tasks(DIRECTORY, last_working_date)

    for task in tasks:
        if TASK_PREFIX in task:
            work_log_tasks.add(
                task.replace("- ", "").replace("[", "").split("]")[0].strip()
            )

    return work_log_tasks


def _get_tasks_from_time_tracker(last_working_date):
    time_tracker_file = f"../tools/time_tracker/tracking_{format_date_to_yyyymmdd_hyphen(last_working_date)}.txt"
    if not os.path.exists(time_tracker_file):
        time_tracker_file = f"../tools/time_tracker/tracking_h_{format_date_to_yyyymmdd_hyphen(last_working_date)}.txt"
        if not os.path.exists(time_tracker_file):
            time_tracker_file = f"../tools/time_tracker/bkup/tracking_{format_date_to_yyyymmdd_hyphen(last_working_date)}.txt"

    if not os.path.exists(time_tracker_file):
        return set()

    with open(time_tracker_file) as file:
        next(file)
        time_tracker_tasks = set()
        task_lines = file.readlines()
        for line in task_lines:
            data = line.replace("\n", "").split(",")
            task = data[1]
            if task.startswith(TASK_PREFIX):
                time_tracker_tasks.add(task)

        return time_tracker_tasks


if __name__ == "__main__":
    main()
