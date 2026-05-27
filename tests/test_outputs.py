import subprocess
import os
import re

OUTPUT_PATH = "/app/output.txt"
REPO_PATH = "/app/repo"


def test_output_presence():
    assert os.path.exists(OUTPUT_PATH), \
        "Expected output artifact was not created."


def _parse_output():
    with open(OUTPUT_PATH) as f:
        content = f.read().strip()

    parsed = {}

    for line in content.splitlines():
        if "=" in line:
            k, v = line.split("=", 1)
            parsed[k.strip()] = v.strip()

    return parsed


def test_output_schema():
    parsed = _parse_output()

    assert "revision" in parsed
    assert "summary" in parsed


def test_revision_format():
    parsed = _parse_output()

    revision = parsed["revision"]

    assert re.fullmatch(r"[0-9a-f]{7,40}", revision)


def test_revision_exists():
    parsed = _parse_output()

    revision = parsed["revision"]

    result = subprocess.run(
        ["git", "cat-file", "-e", revision],
        cwd=REPO_PATH,
        capture_output=True,
    )

    assert result.returncode == 0


def test_behavior_transition():
    parsed = _parse_output()

    revision = parsed["revision"]

    parent = subprocess.check_output(
        ["git", "rev-parse", f"{revision}^"],
        cwd=REPO_PATH,
        text=True,
    ).strip()

    current = subprocess.run(
        ["python", "parser.py"],
        cwd=REPO_PATH,
        capture_output=True,
        text=True,
    )

    previous = subprocess.run(
        ["git", "checkout", parent],
        cwd=REPO_PATH,
        capture_output=True,
        text=True,
    )

    previous_run = subprocess.run(
        ["python", "parser.py"],
        cwd=REPO_PATH,
        capture_output=True,
        text=True,
    )

    subprocess.run(
        ["git", "checkout", revision],
        cwd=REPO_PATH,
        capture_output=True,
        text=True,
    )

    assert current.stdout != previous_run.stdout
