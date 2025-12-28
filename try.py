#!/usr/bin/env python3
import re
import subprocess
import sys
from pathlib import Path


TEST_FILE = Path("./src/check/uf20v90c_test.mbt")
OUTPUT_FILE = Path("./labels.txt")
TIMEOUT_SECONDS = 30


def collect_labels(text: str) -> list[str]:
    labels: list[str] = []
    for line in text.splitlines():
        stripped = line.lstrip()
        if stripped.startswith("//"):
            continue
        match = re.match(r'^\s*test\s+"([^"]+)"', line)
        if match:
            labels.append(match.group(1))
    return labels


def is_oom(returncode: int, stderr: str) -> bool:
    if returncode in (137, -9):
        return True
    if returncode < 0 and -returncode == 9:
        return True
    stderr_lower = stderr.lower()
    return "out of memory" in stderr_lower or "oom" in stderr_lower


def main() -> int:
    if not TEST_FILE.exists():
        print(f"missing test file: {TEST_FILE}", file=sys.stderr)
        return 1

    labels = collect_labels(TEST_FILE.read_text(encoding="utf-8"))
    bad: list[str] = []

    for index, label in enumerate(labels, start=1):
        print(f"[{index}/{len(labels)}] running {label}")
        cmd = ["moon", "test", str(TEST_FILE), "--filter", label]
        try:
            result = subprocess.run(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                timeout=TIMEOUT_SECONDS,
            )
        except subprocess.TimeoutExpired:
            bad.append(label)
            print(f"timeout: {label}")
            continue

        if is_oom(result.returncode, result.stderr):
            bad.append(label)
            print(f"oom: {label}")

    OUTPUT_FILE.write_text("\n".join(bad) + ("\n" if bad else ""), encoding="utf-8")
    print(f"done: {len(labels)} tests checked, {len(bad)} labels recorded")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
