from datetime import datetime

from date_utils import format_date_to_yyyymmdd_hyphen
from read_utils import get_goals
from task_utils import get_last_working_day_tasks

DIRECTORY = "logs"
# TODO to add a goal utils
last_working_date, _ = get_last_working_day_tasks(DIRECTORY, datetime.now())
goals = get_goals(DIRECTORY, last_working_date)

if goals:
    print(f"There is goals set for {format_date_to_yyyymmdd_hyphen(last_working_date)}")
    for goal in goals:
        print(goal)
else:
    print(f"No goals set for {format_date_to_yyyymmdd_hyphen(last_working_date)}")
