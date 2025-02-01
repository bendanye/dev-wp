from datetime import datetime

from date_utils import get_last_working_date, format_date_to_yyyymmdd_hyphen
from task_utils import get_last_working_day_tasks

DIRECTORY = "logs"

last_working_date, tasks = get_last_working_day_tasks(DIRECTORY, datetime.now())

print(format_date_to_yyyymmdd_hyphen(last_working_date))
for task in tasks:
    print(task)
