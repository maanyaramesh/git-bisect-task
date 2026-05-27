#!/bin/bash
set -e

cd /app/repo

BAD_COMMIT=$(git rev-list --reverse HEAD | sed -n '3p')

COMMIT_MSG=$(git log --format=%s -n 1 "$BAD_COMMIT")

cat <<EOF > /app/output.txt
revision: $BAD_COMMIT
summary: $COMMIT_MSG
EOF