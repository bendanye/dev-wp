import random
import sys

from typing import Set


def randomizer(file_path: str) -> None:
    options = get_options(file_path)
    print(f"List of options in {file_path}")
    print("-----")
    for option in options:
        print(option)

    print("-----\n")
    print(f"Randomizer has choose: {random.choice(tuple(options))}")


def get_options(file_path: str) -> Set[str]:
    result = set()
    with open(file_path, 'r') as file:
        items = file.readlines()
        for item in items:
            result.add(item.strip())

    return result


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Missing file path")
        exit(1)

    randomizer(file_path=sys.argv[1])
