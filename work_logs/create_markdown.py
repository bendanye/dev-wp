from typing import List

def create_markdown_file(file_path: str, header: str, lines: List[str]):
    with open(file_path, 'w') as file:
        file.write(f"# {header} \n\n")
        for line in lines:
            file.write(line)
