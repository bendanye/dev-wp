from typing import List
from dataclasses import dataclass

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



def get_lines(file_path: str, criterias: List[Criteria]):
    result = []
    with open(file_path, "r") as file:
        for line_number, line in enumerate(file, start=1):
            if not line.strip():
                continue
            if _is_all_criteria_met(line, criterias):
                result.append(line.strip())

    return result

def _is_all_criteria_met(line: str, criterias: List[Criteria]) -> bool:
    for criteria in criterias:
        if not criteria.is_match(line):
            return False
        
    return True



def _output_result(output_file_path: str, lines: List[str]):
    with open(output_file_path, "w") as file:
        for line in lines:
            file.write(line + "\n")


if __name__ == "__main__":
    input_file_path = "hello.csv"
    output_file_path = "hello_output.csv"

    criterias = []
    criterias.append(Criteria(substring=";True;", is_match_substring=True))
    criterias.append(Criteria(substring=";False", is_match_substring=True))

    result = get_lines(input_file_path, criterias)
    _output_result(output_file_path, result)
