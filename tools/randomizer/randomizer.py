import random
import sys

from typing import Set


def randomizer(file_path: str, count: int = 1) -> None:
    options = get_options(file_path)

    print(f"List of options in {file_path}")
    print("-----")
    for option in options:
        print(option)

    print("-----\n")

    if count > len(options):
        print("Count is larger than available options")
        return

    selected = random.sample(list(options), count)
    print(f"Randomizer has chosen: {selected}")


def get_options(file_path: str) -> Set[str]:
    result = set()
    with open(file_path, "r") as file:
        items = file.readlines()
        for item in items:
            result.add(item.strip())

    return result


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <file_path> [count]")
        exit(1)

    file_path = sys.argv[1]
    count = int(sys.argv[2]) if len(sys.argv) >= 3 else 1

    randomizer(file_path=file_path, count=count)
