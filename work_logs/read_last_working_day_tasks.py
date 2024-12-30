from datetime import timedelta, datetime

from date_utils import get_last_working_date, format_date_to_yyyymmdd_hyphen
from read_utils import get_tasks

last_working_date = get_last_working_date(datetime.now())
# last_working_date = datetime(2024, 12, 25)
lines = get_tasks("examples", last_working_date)

if not lines:
    while not lines:
        last_working_date = get_last_working_date(last_working_date)
        lines = get_tasks("examples", last_working_date)

print(format_date_to_yyyymmdd_hyphen(last_working_date))
for line in lines:
    print(line)
