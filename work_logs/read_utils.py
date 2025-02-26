from date_utils import (
    get_last_monday,
    format_date_to_yyyymmdd,
    format_date_to_yyyymmdd_hyphen,
)


def get_tasks(work_log_directory, specified_date):
    last_monday = get_last_monday(specified_date)
    result = []
    with open(
        f"{work_log_directory}/{format_date_to_yyyymmdd(last_monday)}.md", "r"
    ) as file:
        save_line = False
        for line in file:
            if f"[{format_date_to_yyyymmdd_hyphen(specified_date)}]" in line:
                save_line = True

            if "#### 💡 Learnings" in line and save_line is True:
                save_line = False

            if save_line:
                if "#### Tasks" in line:
                    continue
                elif "### " in line:
                    continue
                else:
                    result.append(line)

    if result and result[-1] == "\n":
        result = result[:-1]

    if len(result) == 3 and result[2].startswith("- [ ]"):
        return []

    return result


def get_specified_tasks(work_log_directory, specified_date, specified_task):
    result = []
    all_tasks = get_tasks(work_log_directory, specified_date)
    save_line = False
    for task in all_tasks:
        if task.startswith("- ") and specified_task in task:
            save_line = True

        elif task.startswith("- ") and save_line is True:
            save_line = False

        if save_line:
            result.append(task)

    if len(result) > 0 and result[-1] == "\n":
        result = result[:-1]

    return result


def get_goals(work_log_directory, specified_date):
    last_monday = get_last_monday(specified_date)
    result = []
    with open(
        f"{work_log_directory}/{format_date_to_yyyymmdd(last_monday)}.md", "r"
    ) as file:
        save_line = False
        on_yesterday_date = False
        for line in file:
            if f"[{format_date_to_yyyymmdd_hyphen(specified_date)}]" in line:
                on_yesterday_date = True

            if "Goals for Next Working Day" in line and on_yesterday_date is True:
                save_line = True

            elif "### " in line and on_yesterday_date is True and save_line is True:
                save_line = False
                on_yesterday_date = False

            if save_line:
                if "Goals for Next Working Day" in line:
                    continue
                else:
                    result.append(line)

    if result[-1] == "\n":
        result = result[:-1]

    if len(result) == 2 and result[1].startswith("- [ ]"):
        return []

    return result
