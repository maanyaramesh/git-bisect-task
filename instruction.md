A regression exists in the git history of /app/repo.

You must identify the FIRST bad commit using git bisect.

The bug is in parser.py.

Expected correct behavior:
Input text should have leading and trailing whitespace removed before converting to uppercase.

Broken behavior:
Whitespace is preserved.

After identifying the first bad commit, create /app/output.txt.

The file must contain EXACTLY these two lines:

revision: <commit hash>
summary: <commit message>

Example:

revision: abc1234
summary: temporary compatibility adjustment

You must output:
- revision (the git commit hash)
- summary (the exact git commit message)