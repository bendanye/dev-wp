from datetime import timedelta, datetime

from date_utils import format_date_to_yyyymmdd_hyphen
from read_utils import get_specified_tasks

DIRECTORY = "logs"

start_date = datetime(2024, 12, 23)
end_date = datetime(2024, 12, 27)
specified_task = "ABCD-1234"

loop_date = start_date

while loop_date < end_date:
    loop_date = loop_date + timedelta(days=1)
    
    if specified_task:
        tasks = get_specified_tasks(DIRECTORY, loop_date, specified_task)
    else:
        tasks = get_tasks(DIRECTORY, loop_date)
        
    if tasks:
        print(format_date_to_yyyymmdd_hyphen(loop_date))
        for task in tasks:
            print(task)
