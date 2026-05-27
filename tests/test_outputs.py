import os
import re
import subprocess

OUTPUT_PATH = "/app/output.txt"
REPO_PATH = "/app/repo"
EXPECTED_SUMMARY = "temporary compatibility adjustment"


def _parse():
    assert os.path.exists(OUTPUT_PATH), "output.txt missing"

    with open(OUTPUT_PATH) as f:
        text = f.read()

    revision = re.search(r"^revision:\s*([a-f0-9]+)$", text, re.M)
    summary = re.search(r"^summary:\s*(.+)$", text, re.M)

    assert revision, "missing revision"
    assert summary, "missing summary"

    return revision.group(1), summary.group(1).strip()


def test_output_exists():
    assert os.path.exists(OUTPUT_PATH)


def test_revision_exists():
    revision, _ = _parse()

    result = subprocess.run(
        ["git", "rev-parse", "--verify", revision],
        cwd=REPO_PATH,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0


def test_correct_first_bad_commit():
    revision, summary = _parse()

    result = subprocess.run(
        ["git", "log", "--format=%s", "-n", "1", revision],
        cwd=REPO_PATH,
        capture_output=True,
        text=True,
    )

    assert result.stdout.strip() == EXPECTED_SUMMARY
    assert summary == EXPECTED_SUMMARY
