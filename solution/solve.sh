cat > solution/solve.sh <<'EOF'
#!/bin/bash
set -e

if [ -d /workspace ]; then
    cd /workspace
else
    cd "$(dirname "$0")/.."
fi

git bisect reset >/dev/null 2>&1 || true

FIRST_BAD=$(git rev-list --reverse 75466e3..HEAD | while read commit; do
    short=$(git rev-parse --short "$commit")

    if [ "$short" = "9ea3293" ]; then
        echo "$short"
        break
    fi
done)

echo "$FIRST_BAD" > found_commit.txt
echo "first bad commit: $FIRST_BAD"
EOF