#!/bin/bash
set -e

cd /workspace/repo

GOOD=$(git rev-list --max-parents=0 HEAD)
BAD=$(git rev-parse HEAD)

git bisect start
git bisect bad "$BAD"
git bisect good "$GOOD"

FIRST_BAD=$(git bisect run bash -c './check.sh >/dev/null 2>&1'; true)

REVISION=$(git rev-parse HEAD)
SUMMARY=$(git log -1 --pretty=%s)

git bisect reset

cat <<EOF > /workspace/output.txt
revision: $REVISION
summary: $SUMMARY
EOF