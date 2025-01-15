import sys

from datetime import datetime, timedelta

# FORMAT = "%Y-%m-%d" # for example 2025-01-11
FORMAT = "%d %b %Y"  # for example 11 Jan 2025

if len(sys.argv) == 1:
    print("Please enter either add/substract and the number of days")
    exit(1)

param = sys.argv[1]

operator = param[0]
if operator not in ["+", "-"]:
    print("The first char should be either + or -")
    exit(1)

days = int(param[1:])

if operator == "+":
    result = datetime.now() + timedelta(days=days)
elif operator == "-":
    result = datetime.now() - timedelta(days=days)

print(result.strftime(FORMAT))
