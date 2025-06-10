#!/usr/bin/env python3

import os
import subprocess
import json


# --- Load environment variables from source.env ---
def load_env(filepath):
    with open(filepath) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" in line:
                key, value = line.split("=", 1)
                os.environ[key.strip()] = value.strip()


# Load env file
load_env("source.env")

# Get schedule file from env
schedule_file = os.environ.get("SCHEDULE_FILE_NAME")
if not schedule_file or not os.path.exists(schedule_file):
    print(f"Error: SCHEDULE_FILE_NAME not set or file not found: {schedule_file}")
    exit(1)

# Read the JSON file
with open(schedule_file, "r") as f:
    data = json.load(f)

# Process each kata
for kata in data.get("katas", []):
    name = kata.get("name")
    repo_dir = kata.get("repo_dir")

    if not repo_dir or not os.path.exists(repo_dir):
        print(f"Skipping {name}: repo directory not found: {repo_dir}")
        continue

    os.chdir(repo_dir)

    if os.path.isdir(".git"):
        print(f"Pulling latest commit for {name}")
        subprocess.run(["git", "pull"], check=False)
    else:
        print(f"Skipping {name}: not a Git repository")
