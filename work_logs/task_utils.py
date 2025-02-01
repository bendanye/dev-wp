from read_utils import get_tasks
from date_utils import get_last_working_date


def get_last_working_day_tasks(work_log_directory, specified_date):
    last_working_date = get_last_working_date(specified_date)
    tasks = get_tasks(work_log_directory, last_working_date)
    if not tasks:
        while not tasks:
            last_working_date = get_last_working_date(last_working_date)
            tasks = get_tasks(work_log_directory, last_working_date)

    return (last_working_date, tasks)
