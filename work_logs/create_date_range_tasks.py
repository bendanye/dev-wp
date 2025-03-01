from datetime import timedelta, datetime

from date_utils import format_date_to_yyyymmdd_hyphen
from read_utils import get_specified_tasks, get_tasks
from create_markdown import create_markdown_file

DIRECTORY = "logs"


def create_markdown_for_tasks_Within(
    start_date, end_date, specified_task: str = ""
) -> None:
    loop_date = start_date

    lines = []

    while loop_date < end_date:
        loop_date = loop_date + timedelta(days=1)
        if specified_task:
            tasks = get_specified_tasks(DIRECTORY, loop_date, specified_task)
        else:
            tasks = get_tasks(DIRECTORY, loop_date)
        if tasks:
            lines.append(f"{format_date_to_yyyymmdd_hyphen(loop_date)}\n")
            for task in tasks:
                lines.append(task)

    header = f"Tasks between {format_date_to_yyyymmdd_hyphen(start_date)} and {format_date_to_yyyymmdd_hyphen(end_date)}"
    create_markdown_file("tmp.md", header, lines)
    print(f"Created markown for {header}")


if __name__ == "__main__":
    end_date = datetime.today() - timedelta(days=1)
    start_date = end_date - timedelta(weeks=2)
    # start_date = datetime(2025, 2, 11)
    # end_date = datetime(2025, 2, 25)
    specified_task = ""
    create_markdown_for_tasks_Within(start_date, end_date, specified_task)
