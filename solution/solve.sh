#!/bin/bash
set -e

cd /workspace/repo

git bisect start
git bisect bad
git bisect good HEAD~5

bad_commit=$(git bisect run ./check.sh 2>/dev/null | \
grep "is the first bad commit" | awk '{print $1}')

summary=$(git log -1 --pretty=%s "$bad_commit")

echo "revision: $bad_commit" > /workspace/output.txt
echo "summary: $summary" >> /workspace/output.txt