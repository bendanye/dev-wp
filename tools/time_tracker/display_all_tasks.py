import glob
import os

SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))


def get_tasks(files, exclude_tasks):
    result = set()

    for file_name in files:
        with open(file_name, "r") as file:
            next(file)
            lines = file.readlines()
            for line in lines:
                data = line.replace("\n", "").split(",")
                task = data[1]
                if task not in exclude_tasks and task != "NIL":
                    result.add(task)

    return result


files = glob.glob(f"{SCRIPT_DIR}/tracking_*.txt")
this_week_tasks = get_tasks(files, set())
print("This week's tasks that were focused on:")
for task in sorted(this_week_tasks):
    print(task)


files = glob.glob(f"{SCRIPT_DIR}/bkup/tracking_*.txt")
remaining_tasks = get_tasks(files, this_week_tasks)
print("\nPrevious weeks' tasks that were focused on:")
for task in sorted(remaining_tasks):
    print(task)
