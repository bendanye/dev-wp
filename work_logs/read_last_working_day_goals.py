from datetime import datetime

from date_utils import get_last_working_date, format_date_to_yyyymmdd_hyphen
from read_utils import get_goals

last_working_date = get_last_working_date(datetime.now())
lines = get_goals("examples", last_working_date)

print(format_date_to_yyyymmdd_hyphen(last_working_date))
if lines:
    for line in lines:
        print(line)
else:
    print("No goals set")
