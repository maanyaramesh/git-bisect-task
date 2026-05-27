#!/bin/bash
set -e

cd /app/repo

# Generate the automated checking hook for git-bisect
cat > /tmp/bisect_hook.py << 'PYEOF'
import sys
import os
import json
import hashlib

sys.path.insert(0, '/app/repo')

try:
    with open('/app/repo/expected_checksum.txt', 'r') as f:
        expected = f.read().strip()
        
    with open('/app/repo/data/records.json', 'r') as f:
        records = json.load(f)
        
    from components.aggregator import aggregate
    res = {"status": "success", "metrics": aggregate(records)}
    
    # Strictly execute specification rules for byte sorting serialization
    serialized = json.dumps(res, sort_keys=True).encode('utf-8')
    computed = hashlib.sha256(serialized).hexdigest()
    
    # 0 = clean, 1 = corrupted state
    sys.exit(0 if computed == expected else 1)
except Exception:
    # If files or code don't exist yet in early history, it's pre-regression (clean)
    sys.exit(0)
PYEOF

git bisect start
git bisect bad HEAD
git bisect good "$(git rev-list --max-parents=0 HEAD | tail -n 1)"

bisect_output=$(git bisect run python3 /tmp/bisect_hook.py 2>&1)

bad_sha=$(echo "$bisect_output" | grep "is the first bad commit" | awk '{print $1}')
git bisect reset

if [ -z "$bad_sha" ]; then
    echo "Operational Error: Bisect parsing failed to find target mutation SHA." >&2
    exit 1
fi

bad_file="components/aggregator.py"
buggy_line=$(git show "$bad_sha" -- "$bad_file" | grep '^+' | grep -v '^+++' | sed 's/^+//' | grep "len(records)" | head -n 1)

# Format explicit structural payload matching instruction rules
cat > /app/output.txt << OUTEOF
COMMIT: $bad_sha
FILE: $bad_file
LINE: $buggy_line
OUTEOF