#!/usr/bin/env python3
import csv
import re
import sys

def parse_two_space_separated(path):
    result = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.rstrip("\n")
            if not line.strip():
                continue
            parts = re.split(r"\s{2,}", line.strip(), maxsplit=1)
            if len(parts) != 2:
                print(f"Skipped line (no '  ' separator found): {line!r}", file=sys.stderr)
                continue
            result.append((parts[0], parts[1]))
    return result

def build_csv(links_txt, md5_file, sha256_file, output_csv):
    links = dict(parse_two_space_separated(links_txt))
    md5_map = {name: checksum for checksum, name in parse_two_space_separated(md5_file)}
    sha256_map = {name: checksum for checksum, name in parse_two_space_separated(sha256_file)}

    with open(output_csv, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["filename", "url", "md5", "sha256"])
        for filename, url in links.items():
            md5 = md5_map.get(filename, "")
            sha256 = sha256_map.get(filename, "")
            if not md5:
                print(f"Missing md5 for file: {filename}", file=sys.stderr)
            if not sha256:
                print(f"Missing sha256 for file: {filename}", file=sys.stderr)
            writer.writerow([filename, url, md5, sha256])

    print(f"Done: {output_csv}")

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print(f"Usage: python {sys.argv[0]} links.txt checksums.md5 checksums.sha256 [result.csv]")
        sys.exit(1)

    links_txt, md5_file, sha256_file = sys.argv[1:4]
    output_csv = sys.argv[4] if len(sys.argv) > 4 else "result.csv"
    build_csv(links_txt, md5_file, sha256_file, output_csv)
