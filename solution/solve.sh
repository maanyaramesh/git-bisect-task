#!/bin/bash
set -e

cd /app/repo

git bisect start
git bisect bad
git bisect good HEAD~7

git bisect run python3 -c "
from parser import parse_value
import sys
sys.exit(0 if parse_value('  hello  ') == 'HELLO' else 1)
" >/dev/null 2>&1

BAD_COMMIT=$(git rev-parse HEAD)
COMMIT_MSG=$(git log --format=%s -n 1 "$BAD_COMMIT")

cat <<EOF >/app/output.txt
revision: $BAD_COMMIT
summary: $COMMIT_MSG
EOF
