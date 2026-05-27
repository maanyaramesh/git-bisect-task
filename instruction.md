A regression was introduced somewhere in this repository's git history.

Use git bisect to identify the first bad commit.

Starting from the current HEAD:
1. Use git bisect to locate the first commit that introduced the regression.
2. Write your result to `/app/output.txt`

The file must contain EXACTLY:

revision: <7-character commit hash>
summary: <commit subject line>

Example format:

revision: abc1234
summary: fix parser edge case