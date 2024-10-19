from typing import List


def get_lines(file_path: str, substring: str, match: bool = True):
    result = []
    with open(file_path, "r") as file:
        for line_number, line in enumerate(file, start=1):
            if not line.strip():
                continue
            if match and substring in line:
                result.append(line.strip())
            if not match and substring not in line:
                result.append(line.strip())

    return result


def _output_result(output_file_path: str, lines: List[str]):
    with open(output_file_path, "w") as file:
        for line in lines:
            file.write(line + "\n")


if __name__ == "__main__":
    input_file_path = "test.log"
    substring = "i am"
    output_file_path = "hello.log"

    result = get_lines(input_file_path, substring, False)
    _output_result(output_file_path, result)
