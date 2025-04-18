import os

from create_markdown import create_markdown_file

DIRECTORY = "logs"


def main() -> None:
    lines = get_learnings()

    header = "Learnings"
    create_markdown_file("learning.md", header, lines)
    print(f"Created markown for {header}")


def get_learnings():
    lines = []
    for filename in os.listdir(DIRECTORY):
        f = os.path.join(DIRECTORY, filename)
        if os.path.isfile(f) and "template.md" not in f and f.endswith(".md"):
            with open(f, "r") as file:
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

    return lines


if __name__ == "__main__":
    main()
