import os
import sys
import glob


def change_current_task(new_task):
    if not new_task:
        print("Please enter the new task to change")
        sys.exit(0)

    script_dir = _get_script_dir()
    timer_file = os.path.join(script_dir, "../pomodoro_timer/timer")

    if not os.path.isfile(timer_file):
        print("There is no timer running now")
        sys.exit(0)

    with open(timer_file, "r") as file:
        lines = file.readlines()

    if not lines:
        print("Timer file is empty")
        sys.exit(0)

    current_task = lines[0].split(",")[1].strip()
    updated_lines = [line.replace(current_task, new_task) for line in lines]

    with open(timer_file, "w") as file:
        file.writelines(updated_lines)

    print(f"Updated current task, {current_task} to {new_task}")


def change_all_matching_task(old_task, new_task):
    if not old_task:
        print("Please enter the old task to change")
        sys.exit(0)
    if not new_task:
        print("Please enter the new task to change")
        sys.exit(0)

    script_dir = _get_script_dir()
    tracking_files = glob.glob(os.path.join(script_dir, "tracking_*.txt"))

    for file_path in tracking_files:
        with open(file_path, "r") as file:
            content = file.read()
        updated_content = content.replace(old_task, new_task)
        with open(file_path, "w") as file:
            file.write(updated_content)

    print(f"Updated all matching tasks, {old_task} to {new_task}")


def _get_script_dir():
    return os.path.dirname(os.path.realpath(__file__))


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please enter the type (CURRENT | ALL)")
        sys.exit(0)

    task_type = sys.argv[1]

    if task_type == "CURRENT":
        change_current_task(sys.argv[2] if len(sys.argv) > 2 else None)
    else:
        change_all_matching_task(
            sys.argv[2] if len(sys.argv) > 2 else None,
            sys.argv[3] if len(sys.argv) > 3 else None,
        )
