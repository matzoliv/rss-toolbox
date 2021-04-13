#!/usr/bin/env python3

import sys
from pathlib import Path

seen_ids = set()

Path(sys.argv[1]).touch()
with open(sys.argv[1], 'r') as input:
    for line in input:
        seen_ids.add(line.split('\t')[0])

with open(sys.argv[1], 'a') as output:
    for line in sys.stdin:
        if line.split('\t')[0] not in seen_ids:
            sys.stdout.write(line)
            output.write(line)
