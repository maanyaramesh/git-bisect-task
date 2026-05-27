import os
import re

OUTPUT_PATH = "/app/output.txt"

EXPECTED_REVISION = "9ea3293"
EXPECTED_SUMMARY = "implement actual git bisect solution"


def parse():
    assert os.path.exists(OUTPUT_PATH), "output.txt missing"

    with open(OUTPUT_PATH) as f:
        text = f.read().strip()

    revision = re.search(r"revision:\s*([a-f0-9]+)", text)
    summary = re.search(r"summary:\s*(.+)", text)

    assert revision, "missing revision"
    assert summary, "missing summary"

    return revision.group(1), summary.group(1).strip()


def test_exact_revision():
    revision, _ = parse()
    assert revision == EXPECTED_REVISION


def test_exact_summary():
    _, summary = parse()
    assert summary == EXPECTED_SUMMARY
