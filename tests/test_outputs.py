from pathlib import Path

def test_output_exists():
    assert Path("/workspace/output.txt").exists()

def test_output_contents():
    content = Path("/workspace/output.txt").read_text()

    assert "revision:" in content
    assert "summary:" in content
    assert "introduce failing behavior" in content
