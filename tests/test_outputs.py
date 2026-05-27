import os
import re
import subprocess

OUTPUT_PATH = "/app/output.txt"
REPO_PATH = "/app/repo"

EXPECTED_SUMMARY = "temporary compatibility adjustment"

def test_target_artifact_presence():
    assert os.path.exists(OUTPUT_PATH), "output.txt missing"

def _parse():
    with open(OUTPUT_PATH) as f:
        text = f.read()

    revision = re.search(r"revision:\s*([a-f0-9]+)", text)
    summary = re.search(r"summary:\s*(.+)", text)

    assert revision, "missing revision"
    assert summary, "missing summary"

    return revision.group(1), summary.group(1).strip()

def test_revision_is_first_bad_commit():
    revision, summary = _parse()

    result = subprocess.run(
        ["git", "log", "--format=%s", "-n", "1", revision],
        cwd=REPO_PATH,
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0
    assert result.stdout.strip() == EXPECTED_SUMMARY
    assert summary == EXPECTED_SUMMARY
