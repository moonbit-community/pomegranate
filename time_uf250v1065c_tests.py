#!/usr/bin/env python3
import re
import subprocess
import sys
import time
from pathlib import Path


DEFAULT_TEST_FILE = Path("src/uf250v1065c_test.mbt")
TEST_RE = re.compile(r'^\s*test\s+"([^"]+)"')


def collect_labels(path: Path) -> list[str]:
    labels: list[str] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.lstrip()
        if stripped.startswith("//"):
            continue
        match = TEST_RE.match(line)
        if match:
            labels.append(match.group(1))
    return labels


def main() -> int:
    timeout = 300.0
    repo_root = Path(__file__).resolve().parent
    test_file = repo_root / DEFAULT_TEST_FILE
    if not test_file.exists():
        print(f"missing test file: {test_file}", file=sys.stderr)
        return 1

    labels = collect_labels(test_file)
    if not labels:
        print(f"no tests found in: {test_file}", file=sys.stderr)
        return 1

    failures = 0
    total = 0.0
    for label in labels:
        cmd = ["moon", "test", str(test_file), "--filter", label]
        start = time.perf_counter()
        try:
            result = subprocess.run(
                cmd,
                cwd=repo_root,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                timeout=timeout,
            )
        except subprocess.TimeoutExpired as exc:
            elapsed = time.perf_counter() - start
            total += elapsed
            failures += 1
            print(f"{label}\t{elapsed:.3f}s\tTIMEOUT")
            if exc.stdout:
                print(exc.stdout, end="")
            if exc.stderr:
                print(exc.stderr, end="", file=sys.stderr)
            continue

        elapsed = time.perf_counter() - start
        total += elapsed
        if result.returncode != 0:
            failures += 1
            print(f"{label}\t{elapsed:.3f}s\tFAIL({result.returncode})")
            if result.stdout:
                print(result.stdout, end="")
            if result.stderr:
                print(result.stderr, end="", file=sys.stderr)
        else:
            print(f"{label}\t{elapsed:.3f}s\tOK")

    print(f"total: {total:.3f}s, failures: {failures}")
    return 0 if failures == 0 else 2


if __name__ == "__main__":
    raise SystemExit(main())
