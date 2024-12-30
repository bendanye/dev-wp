from dataclasses import dataclass
from typing import List


@dataclass
class Criteria:
    substring: str
    is_match_substring: bool

    def is_match(self, line: str) -> bool:
        if self.is_match_substring and self.substring in line:
            return True
        if not self.is_match_substring and self.substring in line:
            return True

        return False


def main(
    criterias: List[Criteria],
    input_path: str,
) -> None:
    blocks = read_blocks_from_file(input_path)

    for block in blocks:
        if _is_all_criteria_met(block, criterias):
            _output_to_terminal(input_path, block)


def read_blocks_from_file(file_path):
    blocks = []
    with open(file_path, "r") as file:
        current_block = []
        for line_number, line in enumerate(file, start=1):
            stripped_line = line.rstrip()
            if not stripped_line:
                if current_block:
                    blocks.append(current_block)
                    current_block = []
            else:
                current_block.append((line_number, stripped_line))

        if current_block:
            blocks.append(current_block)

    return blocks


def _is_all_criteria_met(block, criterias: List[Criteria]) -> bool:
    check_results = []
    for _, line in block:
        for criteria in criterias:
            if criteria.is_match(line):
                check_results.append(True)

    return len(check_results) != len(criterias)


def _output_to_terminal(file_path: str, block) -> None:
    print(f"= {file_path}")
    for line_number, content in block:
        print(f"{line_number}: {content}")


if __name__ == "__main__":
    file_path = "examples/block_example.txt"
    criterias = []
    criterias.append(Criteria(substring="helloworld", is_match_substring=True))
    criterias.append(Criteria(substring="hello2", is_match_substring=False))

    main(criterias, input_path=file_path)
