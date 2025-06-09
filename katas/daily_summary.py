#!/usr/bin/env python3

import os
import sys
import json
import datetime

# Change to script directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))

# Load environment variables from source.env
env_vars = {}
with open("source.env") as f:
    for line in f:
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            key, value = line.split("=", 1)
            env_vars[key.strip()] = value.strip()

SCHEDULE_FILE_NAME = env_vars.get("SCHEDULE_FILE_NAME")
TIME_TAKEN_FILE_NAME = env_vars.get("TIME_TAKEN_FILE_NAME")

if not SCHEDULE_FILE_NAME or not TIME_TAKEN_FILE_NAME:
    raise EnvironmentError("Required environment variables not set")

# Get specified date
if len(sys.argv) > 1:
    specified_date = sys.argv[1]
else:
    specified_date = datetime.date.today().strftime("%Y-%m-%d")

# Get day of week name
days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
day_of_week = days[datetime.datetime.today().weekday()]


# Helper: check if kata has entry for today
def check(dir_path):
    time_file = os.path.join(dir_path, TIME_TAKEN_FILE_NAME)
    if not os.path.isfile(time_file):
        print(f"[ ] {dir_path}")
        return
    with open(time_file) as f:
        for line in f:
            if specified_date in line:
                secs = line.strip().split(",")[-1]
                print(f"[✔] {dir_path} - {secs}s")
                return
    print(f"[ ] {dir_path}")


# Helper: get time in seconds for one kata dir
def time_taken(dir_path):
    time_file = os.path.join(dir_path, TIME_TAKEN_FILE_NAME)
    if not os.path.isfile(time_file):
        return 0
    with open(time_file) as f:
        for line in f:
            if specified_date in line:
                secs = line.strip().split(",")[-1]
                try:
                    return int(secs)
                except ValueError:
                    return 0
    return 0


# Read schedule JSON
with open(SCHEDULE_FILE_NAME) as f:
    schedule = json.load(f)

katas = schedule.get("katas", [])


# Print summary
def print_each_summary():
    for kata in katas:
        day = kata.get("day-of-week", "*")
        if day == day_of_week or day == "*":
            repo_dir = kata.get("repo_dir")
            is_multiple = kata.get("contains-multiple-kata") == "true"
            if is_multiple and os.path.isdir(repo_dir):
                for subdir in sorted(os.listdir(repo_dir)):
                    full_path = os.path.join(repo_dir, subdir)
                    if os.path.isdir(full_path):
                        check(full_path)
            else:
                check(repo_dir)


# Print total time
def print_total_secs():
    total = 0
    for kata in katas:
        day = kata.get("day-of-week", "*")
        if day == day_of_week or day == "*":
            repo_dir = kata.get("repo_dir")
            is_multiple = kata.get("contains-multiple-kata") == "true"
            if is_multiple and os.path.isdir(repo_dir):
                for subdir in os.listdir(repo_dir):
                    full_path = os.path.join(repo_dir, subdir)
                    if os.path.isdir(full_path):
                        total += time_taken(full_path)
            else:
                total += time_taken(repo_dir)
    minutes, seconds = divmod(total, 60)
    print(f"Total time taken: {minutes} minutes {seconds} seconds")


# Run
print_each_summary()
print_total_secs()
