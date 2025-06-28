import os
from datetime import datetime, timedelta

file_name = "helloWorld_yyyymmdd.csv"
date_range = "3 month"
folder_path = "fakefolders"
file_content = "this is mock content"


def main():
    if "month" in date_range:
        days = months_to_days(date_range)

    end_date = datetime.today()
    start_date = end_date - timedelta(days=days)

    # Make sure folder exists
    os.makedirs(folder_path, exist_ok=True)

    current_date = start_date
    while current_date <= end_date:
        if "yyyymmdd" in file_name:
            date_str = current_date.strftime("%Y%m%d")
            new_file_name = file_name.replace("yyyymmdd", date_str)

        file_path = os.path.join(folder_path, new_file_name)

        with open(file_path, "w") as f:
            f.write(f"{file_content} - {date_str}")

        print(f"Created file: {file_path}")

        current_date += timedelta(days=1)


def months_to_days(months_str):
    num = int(months_str.split()[0])
    return num * 30


if __name__ == "__main__":
    main()
