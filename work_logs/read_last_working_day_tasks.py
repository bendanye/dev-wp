from datetime import datetime

from date_utils import get_last_working_date, format_date_to_yyyymmdd_hyphen
from read_utils import get_tasks

DIRECTORY = "logs"

last_working_date = get_last_working_date(datetime.now())
tasks = get_tasks(DIRECTORY, last_working_date)

if not tasks:
    while not tasks:
        last_working_date = get_last_working_date(last_working_date)
        tasks = get_tasks(DIRECTORY, last_working_date)

print(format_date_to_yyyymmdd_hyphen(last_working_date))
for task in tasks:
    print(task)
