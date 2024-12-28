import os.path

from date_utils import (
    get_last_monday,
    format_date_to_yyyymmdd,
    format_date_to_yyyymmdd_hyphen,
)

from datetime import timedelta, date

monday = get_last_monday(date.today())

work_log_file_name = format_date_to_yyyymmdd(monday)

if os.path.isfile(f"{work_log_file_name}.md"):
    print("This week work log is already exists. Skip creating")
else:
    with open("template.md", "r") as fin:
        with open(f"{work_log_file_name}.md", "w") as fout:
            for line in fin:
                if "## Week of [Month Day, Year]" in line:
                    fout.write(
                        line.replace(
                            "## Week of [Month Day, Year]",
                            f'## Week of [{monday.strftime("%d %m, %Y")}]',
                        )
                    )
                elif "### Monday, [Date]" in line:
                    fout.write(
                        line.replace(
                            "### Monday, [Date]",
                            f"### Monday, [{format_date_to_yyyymmdd_hyphen(monday)}]",
                        )
                    )
                elif "### Tuesday, [Date]" in line:
                    tuesday = monday + timedelta(+1)
                    fout.write(
                        line.replace(
                            "### Tuesday, [Date]",
                            f"### Tuesday, [{format_date_to_yyyymmdd_hyphen(tuesday)}]",
                        )
                    )
                elif "### Wednesday, [Date]" in line:
                    wednesday = monday + timedelta(+2)
                    fout.write(
                        line.replace(
                            "### Wednesday, [Date]",
                            f"### Wednesday, [{format_date_to_yyyymmdd_hyphen(wednesday)}]",
                        )
                    )
                elif "### Thursday, [Date]" in line:
                    thursday = monday + timedelta(+3)
                    fout.write(
                        line.replace(
                            "### Thursday, [Date]",
                            f"### Thursday, [{format_date_to_yyyymmdd_hyphen(thursday)}]",
                        )
                    )
                elif "### Friday, [Date]" in line:
                    friday = monday + timedelta(+4)
                    fout.write(
                        line.replace(
                            "### Friday, [Date]",
                            f"### Friday, [{format_date_to_yyyymmdd_hyphen(friday)}]",
                        )
                    )
                else:
                    fout.write(line)
