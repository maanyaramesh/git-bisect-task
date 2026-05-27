# Git Bisect Task

A git repository is located at:

/workspace/repo

The script:

./check.sh

returns:
- exit code 0 for good commits
- non-zero exit code for bad commits

One commit introduced a regression.

Your task is to use `git bisect` to identify the FIRST bad commit.

After identifying the commit, create a file EXACTLY at:

/workspace/output.txt

The file must contain EXACTLY TWO lines in this format:

revision: <commit hash>
summary: <commit message>

Example:

revision: abc1234
summary: introduce failing behavior

Requirements:
- You must determine the answer dynamically using git history
- Do not hardcode the commit hash
- The commit hash may be abbreviated or full-length
