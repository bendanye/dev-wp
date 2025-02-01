import os
import json


from datetime import datetime
from task_utils import get_last_working_day_tasks
from date_utils import format_date_to_yyyymmdd_hyphen

LOGS_DIRECTORY = "logs"
CHECK_TASK_JSON_DIRECTORY = "."

# specified_date = datetime(2024, 12, 25)
specified_date = datetime.now()


def main() -> None:
    last_working_date, work_tasks = get_last_working_day_tasks(
        LOGS_DIRECTORY, specified_date
    )
    day_of_week = last_working_date.strftime("%A")
    with open(f"{CHECK_TASK_JSON_DIRECTORY}/check_tasks.json") as json_file:
        check_tasks = json.load(json_file)["tasks"]
        for check_task in check_tasks:
            if check_task["day-of-week"] == day_of_week:
                for work_task in work_tasks:
                    if check_task["name"] in work_task:
                        print(
                            f'{check_task["name"]} is found in last working day ({format_date_to_yyyymmdd_hyphen(last_working_date)})'
                        )


if __name__ == "__main__":
    main()
