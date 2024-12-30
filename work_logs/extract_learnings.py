import os

DIRECTORY = "logs"

for filename in os.listdir(DIRECTORY):
    f = os.path.join(DIRECTORY, filename)
    if os.path.isfile(f) and "template.md" not in f and f.endswith(".md"):
        with open(f, "r") as file:
            lines = []
            save_line = False
            for line in file:
                if "#### 💡 Learnings" in line:
                    save_line = True

                elif "### " in line and save_line is True:
                    save_line = False

                if save_line and (
                    "#### 💡 Learnings" not in line
                    and "- [ ]" not in line
                    and "\n" != line
                ):
                    lines.append(line)

            for line in lines:
                print(line)
