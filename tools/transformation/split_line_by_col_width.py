def split_long_lines(input_file, output_file, max_length=3000):
    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        for line in infile:
            while len(line) > max_length:
                split_index = line[:max_length].rfind(",")
                if split_index == -1:
                    raise ValueError(
                        "Line exceeds max_length without a comma for splitting."
                    )

                outfile.write(line[: split_index + 1] + "\n")
                line = line[split_index + 1 :].lstrip()

            outfile.write(line)

    print(f"Processed lines have been written to {output_file}")


# Example usage
input_file_path = "examples/1.sql"
output_file_path = "examples/1_output.sql"
split_long_lines(input_file_path, output_file_path, max_length=30)
