import os.path

from date_utils import get_last_monday

from datetime import timedelta, date

monday = get_last_monday(date.today())

if os.path.isfile(f'{monday.strftime("%Y%m%d")}.md'):
    print("This week work log is already exists. Skip creating")
else:
    with open("template.md", "r") as fin:
        with open(f'{monday.strftime("%Y%m%d")}.md', "w") as fout:
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
                            f'### Monday, [{monday.strftime("%Y-%m-%d")}]',
                        )
                    )
                elif "### Tuesday, [Date]" in line:
                    tuesday = monday + timedelta(+1)
                    fout.write(
                        line.replace(
                            "### Tuesday, [Date]",
                            f'### Tuesday, [{tuesday.strftime("%Y-%m-%d")}]',
                        )
                    )
                elif "### Wednesday, [Date]" in line:
                    wednesday = monday + timedelta(+2)
                    fout.write(
                        line.replace(
                            "### Wednesday, [Date]",
                            f'### Wednesday, [{wednesday.strftime("%Y-%m-%d")}]',
                        )
                    )
                elif "### Thursday, [Date]" in line:
                    thursday = monday + timedelta(+3)
                    fout.write(
                        line.replace(
                            "### Thursday, [Date]",
                            f'### Thursday, [{thursday.strftime("%Y-%m-%d")}]',
                        )
                    )
                elif "### Friday, [Date]" in line:
                    friday = monday + timedelta(+4)
                    fout.write(
                        line.replace(
                            "### Friday, [Date]",
                            f'### Friday, [{friday.strftime("%Y-%m-%d")}]',
                        )
                    )
                else:
                    fout.write(line)
