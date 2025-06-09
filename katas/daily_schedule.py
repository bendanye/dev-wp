#!/usr/bin/env python3

import os
import json
import datetime

# Move to the script's directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))

# Manually load environment variables from source.env
env_file = "source.env"
if not os.path.exists(env_file):
    raise FileNotFoundError(f"{env_file} not found")

with open(env_file) as f:
    for line in f:
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            key, value = line.split("=", 1)
            os.environ[key.strip()] = value.strip()

# Get the current day of the week
days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
day_of_week = days[datetime.datetime.today().weekday()]

# Load the JSON file
schedule_file_name = os.getenv("SCHEDULE_FILE_NAME")
if not schedule_file_name:
    raise EnvironmentError("SCHEDULE_FILE_NAME environment variable is not set")

if not os.path.exists(schedule_file_name):
    raise FileNotFoundError(f"{schedule_file_name} does not exist")

with open(schedule_file_name) as f:
    data = json.load(f)

# Iterate through katas
kata_found = False
for kata in data.get("katas", []):
    name = kata.get("name", "Unnamed Kata")
    day = kata.get("day-of-week", "*")

    if day == day_of_week or day == "*":
        kata_found = True
        print(f"There is planned kata, '{name}' on {day_of_week}")

if not kata_found:
    print(f"There is no kata planned on {day_of_week}")
