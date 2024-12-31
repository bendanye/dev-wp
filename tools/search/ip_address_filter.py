import re
import os

COMMON_SKIP_DIRECTORIES = [".git", ".idea"]


def main(input_path: str) -> None:
    if os.path.isfile(input_path):
        _start_from_file(input_path)
    else:
        _start_from_directory(input_path)


def _start_from_file(file_path: str) -> None:
    ips_with_lines = _find_ip_addresses_with_line_numbers(file_path)
    _output_to_terminal(file_path, ips_with_lines)


def _start_from_directory(input_path: str):
    for subdir, dirs, files in os.walk(input_path):
        for file in files:
            for skip_directory in COMMON_SKIP_DIRECTORIES:
                if skip_directory in dirs:
                    dirs.remove(skip_directory)

            absolute_path = os.path.join(subdir, file)
            if os.path.isfile(absolute_path):
                ips_with_lines = _find_ip_addresses_with_line_numbers(absolute_path)
                _output_to_terminal(absolute_path, ips_with_lines)


def _find_ip_addresses_with_line_numbers(file_path):
    ip_pattern = r"\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b"
    results = []

    with open(file_path, "r") as file:
        for line_number, line in enumerate(file, start=1):
            ip_addresses = re.findall(ip_pattern, line)

            valid_ips = [
                ip
                for ip in ip_addresses
                if all(0 <= int(octet) <= 255 for octet in ip.split("."))
            ]

            for ip in valid_ips:
                results.append((line_number, line, ip))

    return results


def _output_to_terminal(input_path: str, lines) -> None:
    print(f"Total count: {len(lines)}")
    for line_num, line, ip in lines:
        print(f"{input_path}: Line {line_num} - {line.strip()}")


if __name__ == "__main__":
    main("examples/ip_address_example.txt")
