from pathlib import Path

def test_output_exists():
    output = Path("/workspace/output.txt")
    assert output.exists(), "output.txt was not created"

def test_output_format():
    text = Path("/workspace/output.txt").read_text()

    assert "revision:" in text
    assert "summary:" in text
