FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ALLOW_INTERNET=false

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --break-system-packages pytest==8.3.4

RUN git config --global user.email "core-dev@engine.internal" \
 && git config --global user.name "Core Engine Dev" \
 && git config --global init.defaultBranch master

WORKDIR /app
RUN mkdir -p repo && git -C /app/repo init && git -C /app/repo checkout -b master

# Setup reproducible history using data-dependent calculation mutations.
RUN cat << 'EOF' > /tmp/setup_repo.py
import os
import subprocess
import json

def c(m):
    subprocess.run(['git', '-C', '/app/repo', 'add', '.'], check=True)
    subprocess.run(['git', '-C', '/app/repo', 'commit', '-m', m], check=True)

def w(f, n):
    p = os.path.join('/app/repo', f)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, 'w') as src:
        src.write(n)

# Create clean linear baseline history
w('data/records.json', '[{"id": 1, "value": 10}, {"id": 2, "value": 20}, {"id": 3, "value": 15}]')
w('main.py', 'import json\nfrom components.aggregator import aggregate\nwith open("data/records.json") as f:\n    data = json.load(f)\nprint(f"Result: {aggregate(data)}")')
w('components/aggregator.py', 'def aggregate(records):\n    return {"total": sum(r["value"] for r in records), "count": len(records)}')
c('Initial architectural implementation')

# Intermediary commits to stretch history depth
w('README.md', '# Performance Execution Core\nPipeline interface tracking v1.0')
c('Docs update')

# THE REGRESSION: Bug injection that dynamically checks record field characteristics
w('components/aggregator.py', 'def aggregate(records):\n    val = sum(r["value"] for r in records)\n    if len(records) % 2 != 0:\n        val -= sum(1 for r in records if r.get("value", 0) > 15)\n    return {"total": val, "count": len(records)}')
c('Optimize compilation and aggregation loop bindings')

# Post-regression history extensions
w('config.json', '{"env": "production", "workers": 4}')
c('Deploy environment config specification')
EOF

RUN python3 /tmp/setup_repo.py

# Compute explicit ground truth checksum matching a clean run state
RUN cat << 'EOF' > /tmp/compute_checksum.py
import json
import hashlib

with open('/app/repo/data/records.json') as f:
    data = json.load(f)

# Ground truth behavior (without the modulus bug regression logic)
total = sum(r['value'] for r in data)
res = {'status': 'success', 'metrics': {'total': total, 'count': len(data)}}
serialized = json.dumps(res, sort_keys=True).encode('utf-8')
computed = hashlib.sha256(serialized).hexdigest()

with open('/app/repo/expected_checksum.txt', 'w') as f:
    f.write(computed)
EOF

RUN python3 /tmp/compute_checksum.py