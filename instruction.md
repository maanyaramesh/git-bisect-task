A regression was introduced somewhere in the repository history.

The repository contains a small parser pipeline whose output changes unexpectedly for certain multi-line inputs.

Your task is to identify the first bad commit that introduced the behavioral change.

Write the identified commit hash to /app/output.txt using the format:

first_bad_commit=<hash>

The hash must correspond to an actual commit inside the repository history.A behavior change was introduced somewhere in the repository history.

The current version produces incorrect output for one production scenario, while older revisions behave correctly.

Investigate the repository history and determine which revision introduced the behavior change.

When you finish, write your findings to:

/app/output.txt

Format:

revision=<commit_hash>
summary=<short explanation>
