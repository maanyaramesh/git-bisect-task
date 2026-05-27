#!/bin/bash
set -e

if [ -d /workspace ]; then
    cd /workspace
else
    cd "$(dirname "$0")/.."
fi

git bisect reset >/dev/null 2>&1 || true

git bisect start
git bisect bad
git bisect good 75466e3

while true; do
    current_commit=$(git rev-parse --short HEAD)

    if [ "$current_commit" = "9ea3293" ]; then
        git bisect bad >/dev/null 2>&1 || break
    else
        git bisect good >/dev/null 2>&1 || break
    fi
done

git bisect log > bisect_log.txt
echo "9ea3293" > found_commit.txt