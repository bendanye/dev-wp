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

    if result[-1] == "\n":
        result = result[:-1]

    if len(result) == 1 and result[0].startswith("- [ ]"):
        return []

    return result
