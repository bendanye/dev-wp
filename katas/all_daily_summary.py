import os
import sys
import json
from datetime import datetime


# Load environment variables from source.env
def load_env(filename):
    env_vars = {}
    with open(filename) as f:
        for line in f:
            if line.strip() and not line.startswith("#"):
                key, val = line.strip().split("=", 1)
                env_vars[key] = val
    return env_vars


# Get the script's current directory
script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)

# Load env vars
env = load_env("source.env")
TIME_TAKEN_FILE_NAME = env["TIME_TAKEN_FILE_NAME"]
SCHEDULE_FILE_NAME = env["SCHEDULE_FILE_NAME"]

# Get specified date
specified_date = (
    sys.argv[1] if len(sys.argv) > 1 else datetime.now().strftime("%Y-%m-%d")
)


def check(dir_path):
    time_file = os.path.join(dir_path, TIME_TAKEN_FILE_NAME)
    if not os.path.isfile(time_file):
        print(f"[ ] {dir_path}")
        return
    with open(time_file) as f:
        lines = f.readlines()
    match = [line for line in lines if specified_date in line]
    if match:
        secs = match[0].strip().split(",")[-1]
        print(f"[✔] {dir_path} - {secs}s")
    else:
        print(f"[ ] {dir_path}")


def time_taken(dir_path):
    time_file = os.path.join(dir_path, TIME_TAKEN_FILE_NAME)
    if not os.path.isfile(time_file):
        return 0
    with open(time_file) as f:
        lines = f.readlines()
    match = [line for line in lines if specified_date in line]
    if match:
        return int(match[0].strip().split(",")[-1])
    return 0


def print_each_summary():
    with open(SCHEDULE_FILE_NAME) as f:
        schedule = json.load(f)
    for kata in schedule["katas"]:
        kata_dir = kata["repo_dir"]
        multiple = kata.get("contains-multiple-kata", False)
        if multiple:
            exclude_katas = kata.get("exclude_katas", "").split(",")
            for subdir in sorted(os.listdir(kata_dir)):
                full_path = os.path.join(kata_dir, subdir)
                if (
                    subdir not in exclude_katas
                    and os.path.isdir(full_path)
                    and not full_path.endswith(".git")
                ):
                    check(full_path)
        else:
            check(kata_dir)


def print_total_secs():
    total_secs = 0
    with open(SCHEDULE_FILE_NAME) as f:
        schedule = json.load(f)
    for kata in schedule["katas"]:
        kata_dir = kata["repo_dir"]
        multiple = kata.get("contains-multiple-kata", False)
        if multiple:
            exclude_katas = kata.get("exclude_katas", "").split(",")
            for subdir in sorted(os.listdir(kata_dir)):
                full_path = os.path.join(kata_dir, subdir)
                if (
                    subdir not in exclude_katas
                    and os.path.isdir(full_path)
                    and not full_path.endswith(".git")
                ):
                    total_secs += time_taken(full_path)
        else:
            total_secs += time_taken(kata_dir)
    minutes = total_secs // 60
    seconds = total_secs % 60
    print(f"Total time taken: {minutes} minutes {seconds} seconds")


if __name__ == "__main__":
    print_each_summary()
    print_total_secs()
