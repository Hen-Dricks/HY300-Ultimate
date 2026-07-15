#!/usr/bin/env python3
from __future__ import annotations
import argparse, hashlib
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument("--root", type=Path, required=True)
p.add_argument("--output", type=Path, required=True)
a = p.parse_args()

skip = {a.output.resolve()}
rows = []
for path in sorted(a.root.rglob("*")):
    if not path.is_file() or path.resolve() in skip:
        continue
    h = hashlib.sha256()
    try:
        with path.open("rb") as f:
            for chunk in iter(lambda: f.read(1024*1024), b""):
                h.update(chunk)
        rows.append(f"{h.hexdigest()}  {path.relative_to(a.root)}")
    except OSError:
        pass

a.output.parent.mkdir(parents=True, exist_ok=True)
a.output.write_text("\n".join(rows) + "\n", encoding="utf-8")
