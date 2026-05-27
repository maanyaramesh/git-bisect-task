#!/bin/bash
set -e

if [ -d /workspace ]; then
    cd /workspace
else
    cd "$(dirname "$0")/.."
fi

bash solution/solve.sh

python3 -m pytest tests/test_outputs.py -q || true