import os
import sys
import time
from datetime import datetime, timedelta


def clear_screen():
    os.system("cls" if os.name == "nt" else "clear")


def main():
    # Determine the task
    task = sys.argv[1] if len(sys.argv) > 1 else "MISC"

    # Determine script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    timer_file = os.path.join(script_dir, "timer")

    if os.path.isfile(timer_file):
        clear_screen()

        with open(timer_file, "r") as f:
            content = f.read().strip()
        start_str, task_from_file = content.split(",", 1)
        task = task_from_file
        start = int(start_str)

        os.remove(timer_file)
        end = int(time.time())

        end_time = datetime.now().strftime("%H:%M")
        print(f"Stop timer at {end_time}")

        secs = end - start
        desk_time = secs // 60
        resting_time = desk_time // 5

        rest_until = (datetime.now() + timedelta(minutes=resting_time)).strftime(
            "%H:%M"
        )

        if task == "MISC":
            print(f"Total minutes at my desk time: {desk_time}")
        else:
            print(f"Total minutes at my desk time focusing on {task}: {desk_time}")

        if resting_time == 0:
            print(
                "Please check the communication tools and take a short break if required"
            )
        else:
            print(
                f"Please check the communication tools and take a break for {resting_time} minutes until {rest_until}"
            )
    else:
        clear_screen()
        print("Start timer")
        start = int(time.time())
        with open(timer_file, "w") as f:
            f.write(f"{start},{task}")


if __name__ == "__main__":
    main()
