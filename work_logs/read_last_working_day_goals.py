from datetime import datetime

from date_utils import get_last_working_date, format_date_to_yyyymmdd_hyphen
from read_utils import get_goals, get_tasks

DIRECTORY = "examples"

last_working_date = get_last_working_date(datetime.now())
tasks = get_tasks(DIRECTORY, last_working_date)

if not tasks:
    while not tasks:
        last_working_date = get_last_working_date(last_working_date)
        tasks = get_tasks(DIRECTORY, last_working_date)

goals = get_goals(DIRECTORY, last_working_date)

print(format_date_to_yyyymmdd_hyphen(last_working_date))
if goals:
    for goal in goals:
        print(goal)
else:
    print("No goals set")
