import glob
import os

SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))

tasks = set()

files = glob.glob(f"{SCRIPT_DIR}/tracking_*.txt")
files = files + glob.glob(f"{SCRIPT_DIR}/bkup/tracking_*.txt")

for file_name in files:
    with open(file_name, "r") as file:
        next(file)
        lines = file.readlines()
        for line in lines:
            data = line.replace("\n", "").split(",")
            tasks.add(data[1])

for task in sorted(tasks):
    if task != "NIL":
        print(task)
