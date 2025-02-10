def add_line_after(filename, target_line, new_line):
    with open(filename, "r") as file:
        lines = file.readlines()

    updated_lines = []
    for line in lines:
        updated_lines.append(line)
        if target_line in line:
            indent = line[: len(line) - len(line.lstrip())]
            updated_lines.append(indent + new_line + "\n")

    with open(filename, "w") as file:
        file.writelines(updated_lines)


def add_line_before(filename, target_line, new_line):
    with open(filename, "r") as file:
        lines = file.readlines()

    updated_lines = []
    for line in lines:
        if target_line in line:
            indent = line[: len(line) - len(line.lstrip())]
            updated_lines.append(indent + new_line + "\n")
        updated_lines.append(line)

    with open(filename, "w") as file:
        file.writelines(updated_lines)


def replace_line(filename, old_line, new_line):
    with open(filename, "r") as file:
        lines = file.readlines()

    updated_lines = [line.replace(old_line, new_line) for line in lines]

    with open(filename, "w") as file:
        file.writelines(updated_lines)


filename = "examples/line.txt"
add_line_after(filename, "this is line 3", "this is a new line after")
add_line_before(filename, "this is line 3", "this is a new line before")
replace_line(filename, "this is line 4 extra", "this is line 4 extra change")
