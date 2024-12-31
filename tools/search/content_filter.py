import os

from typing import List
from dataclasses import dataclass

COMMON_SKIP_DIRECTORIES = [".git", ".idea"]


@dataclass
class Criteria:
    substring: str
    is_match_substring: bool

    def is_match(self, line: str) -> bool:
        if self.is_match_substring and self.substring in line:
            return True
        if not self.is_match_substring and self.substring not in line:
            return True

        return False


@dataclass
class Line:
    file_path: str
    number: int
    content: str


def main(
    criterias: List[Criteria],
    input_path: str,
    output_file_path: str,
    show_all_details: bool = False,
) -> None:
    if os.path.isfile(input_path):
        _start_from_file(criterias, input_path, output_file_path, show_all_details)
    else:
        _start_from_directory(criterias, input_path, output_file_path, show_all_details)


def _start_from_file(
    criterias: List[Criteria],
    input_path: str,
    output_file_path: str,
    show_all_details: bool,
) -> None:
    lines = get_lines(input_path, criterias)
    if output_file_path:
        _output_to_file(output_file_path, lines, show_all_details)
    else:
        _output_to_terminal(lines, show_all_details)


def _start_from_directory(
    criterias: List[Criteria],
    input_path: str,
    output_file_path: str,
    show_all_details: bool,
) -> None:
    for subdir, dirs, files in os.walk(input_path):
        for file in files:
            for skip_directory in COMMON_SKIP_DIRECTORIES:
                if skip_directory in dirs:
                    dirs.remove(skip_directory)

            absolute_path = os.path.join(subdir, file)
            if os.path.isfile(absolute_path):
                lines = get_lines(absolute_path, criterias)

                if output_file_path:
                    _output_to_file(output_file_path, lines, show_all_details)
                else:
                    _output_to_terminal(lines, show_all_details)


def get_lines(file_path: str, criterias: List[Criteria]) -> List[Line]:
    result = []
    with open(file_path, "r") as file:
        for line_number, line in enumerate(file, start=1):
            if not line.strip():
                continue
            if _is_all_criteria_met(line, criterias):
                result.append(
                    Line(file_path=file_path, number=line_number, content=line.strip())
                )

    return result


def _is_all_criteria_met(line: str, criterias: List[Criteria]) -> bool:
    for criteria in criterias:
        if not criteria.is_match(line):
            return False

    return True


def _output_to_file(output_file_path: str, lines: List[Line], show_all_detail: bool):
    with open(output_file_path, "w") as file:
        for line in lines:
            if show_all_detail:
                file.write(
                    f"File={line.file_path};Line number={line.number};{line.content}\n"
                )
            else:
                file.write(f"{line.content}\n")


def _output_to_terminal(lines: List[Line], show_all_detail: bool):
    print(f"Total count: {len(lines)}")
    for line in lines:
        if show_all_detail:
            print(f"File={line.file_path};Line number={line.number};{line.content}")
        else:
            print(line.content)


if __name__ == "__main__":
    input_path = "examples/example1.csv"
    output_file_path = "examples/example1_output.csv"

    criterias = []
    criterias.append(Criteria(substring=";True;", is_match_substring=True))
    criterias.append(Criteria(substring=";False", is_match_substring=True))

    main(criterias, input_path, output_file_path, show_all_details=False)
