#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
from pathlib import Path
import re

# 匹配：文件末尾的 "%\n0\n"（或 "%\r\n0\r\n"），以及其后全部空白（空行、空格、tab等）
TAIL_PATTERN = re.compile(r'(?:%\r?\n0\r?\n)\s*\Z')

def strip_tail(text: str) -> tuple[str, bool]:
    new_text, n = TAIL_PATTERN.subn('', text)
    return new_text, (n > 0)

def main():
    parser = argparse.ArgumentParser(
        description='Remove trailing "%\\n0\\n" (DIMACS-style) and following blank lines at EOF.'
    )
    parser.add_argument('file', type=Path, help='Path to the text file')
    parser.add_argument('--inplace', action='store_true', help='Modify file in place')
    parser.add_argument('-o', '--output', type=Path, help='Write result to output file (default: stdout)')
    args = parser.parse_args()

    raw = args.file.read_text(encoding='utf-8', errors='strict')
    cleaned, changed = strip_tail(raw)

    if args.inplace:
        if changed:
            args.file.write_text(cleaned, encoding='utf-8', newline='\n')
        return

    if args.output:
        args.output.write_text(cleaned, encoding='utf-8', newline='\n')
        return

    # 默认输出到 stdout
    print(cleaned, end='')

if __name__ == '__main__':
    main()
