#!/usr/bin/env python3
from __future__ import annotations
import argparse, re, shutil
from pathlib import Path
from datetime import datetime, timezone

p = argparse.ArgumentParser()
p.add_argument("--run-id", required=True)
p.add_argument("--logs", type=Path, required=True)
p.add_argument("--reports", type=Path, required=True)
p.add_argument("--assets", type=Path, required=True)
a = p.parse_args()
a.reports.mkdir(parents=True, exist_ok=True)

def read(rel: str) -> str:
    path = a.logs / rel
    if not path.exists():
        return ""
    return path.read_text(encoding="utf-8", errors="replace")

def command_body(text: str) -> str:
    lines = text.splitlines()
    while lines and (lines[0].startswith("#") or not lines[0].strip()):
        lines.pop(0)
    return "\n".join(lines).strip()

getprop = command_body(read("android/getprop.txt"))
props = {}
for line in getprop.splitlines():
    m = re.match(r"\[([^\]]+)\]: \[(.*)\]", line)
    if m:
        props[m.group(1)] = m.group(2)

def prop(*names: str) -> str:
    for n in names:
        if props.get(n):
            return props[n]
    return "Not reported"

def code(rel: str, max_chars: int = 12000) -> str:
    txt = command_body(read(rel))
    if len(txt) > max_chars:
        txt = txt[:max_chars] + "\n\n[Output truncated in report; see raw log.]"
    return "```text\n" + txt + "\n```" if txt else "_Not available._"

generated = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%SZ")

hardware = f"""---
title: "Device Hardware Report"
run_id: "{a.run_id}"
generated_utc: "{generated}"
---

# Device Hardware Report

| Field | Value |
|---|---|
| Manufacturer | `{prop('ro.product.manufacturer', 'ro.product.vendor.manufacturer')}` |
| Brand | `{prop('ro.product.brand', 'ro.product.vendor.brand')}` |
| Model | `{prop('ro.product.model', 'ro.product.vendor.model')}` |
| Device | `{prop('ro.product.device', 'ro.product.vendor.device')}` |
| Board | `{prop('ro.product.board', 'ro.board.platform')}` |
| Hardware | `{prop('ro.hardware')}` |
| ABI | `{prop('ro.product.cpu.abi')}` |
| ABI list | `{prop('ro.product.cpu.abilist')}` |

## Kernel

{code('hardware/uname.txt')}

## CPU

{code('hardware/cpuinfo.txt')}

## Memory

{code('hardware/meminfo.txt')}
"""

software = f"""---
title: "Android Software Report"
run_id: "{a.run_id}"
generated_utc: "{generated}"
---

# Android Software Report

| Field | Value |
|---|---|
| Android version | `{prop('ro.build.version.release')}` |
| SDK level | `{prop('ro.build.version.sdk')}` |
| Build ID | `{prop('ro.build.id')}` |
| Display ID | `{prop('ro.build.display.id')}` |
| Fingerprint | `{prop('ro.build.fingerprint')}` |
| Security patch | `{prop('ro.build.version.security_patch')}` |
| Build type | `{prop('ro.build.type')}` |
| Build tags | `{prop('ro.build.tags')}` |

## HOME Activity

{code('android/home-activity.txt')}

## Installed Packages

{code('android/packages-all.txt', 20000)}
"""

partitions = f"""---
title: "Partition and Mount Report"
run_id: "{a.run_id}"
generated_utc: "{generated}"
---

# Partition and Mount Report

## Named Partitions

{code('partitions/by-name.txt')}

## Kernel Partition Table

{code('partitions/proc-partitions.txt')}

## Mounted Filesystems

{code('partitions/mount.txt')}

## Filesystem Usage

{code('partitions/df.txt')}

## fstab Sources

{code('partitions/fstab-files.txt', 20000)}
"""

security = f"""---
title: "Security Posture Report"
run_id: "{a.run_id}"
generated_utc: "{generated}"
---

# Security Posture Report

## SELinux Mode

{code('security/selinux-mode.txt')}

## Verified Boot and AVB Properties

{code('security/avb-properties.txt')}

## Process Security Contexts

{code('services/processes-selinux.txt', 18000)}

## Device Policy

{code('security/device-policy.txt')}
"""

performance = f"""---
title: "Performance Baseline Report"
run_id: "{a.run_id}"
generated_utc: "{generated}"
---

# Performance Baseline Report

This file records a static baseline. For meaningful comparisons, repeat collection under equivalent boot, temperature, network, and workload conditions.

## Memory

{code('hardware/meminfo.txt')}

## Filesystem Usage

{code('partitions/df.txt')}

## Running Processes

{code('services/processes.txt', 20000)}

## Power State

{code('power/power.txt')}
"""

validation = f"""---
title: "Collection Validation Report"
run_id: "{a.run_id}"
generated_utc: "{generated}"
---

# Collection Validation Report

| Check | Result |
|---|---|
| Android properties collected | `{'Yes' if getprop else 'No'}` |
| Partition map collected | `{'Yes' if command_body(read('partitions/by-name.txt')) else 'No'}` |
| Process list collected | `{'Yes' if command_body(read('services/processes.txt')) else 'No'}` |
| SurfaceFlinger report collected | `{'Yes' if command_body(read('graphics/surfaceflinger.txt')) else 'No'}` |
| SELinux state collected | `{'Yes' if command_body(read('security/selinux-mode.txt')) else 'No'}` |
| Network state collected | `{'Yes' if command_body(read('network/ip-address.txt')) else 'No'}` |

> [!IMPORTANT]
> Review every public artifact manually. Automatic redaction reduces risk but cannot guarantee that all private or device-specific information has been removed.
"""

files = {
    "hardware-report.md": hardware,
    "software-report.md": software,
    "partition-report.md": partitions,
    "security-report.md": security,
    "performance-baseline.md": performance,
    "validation-report.md": validation,
}
for name, text in files.items():
    (a.reports / name).write_text(text, encoding="utf-8")

# Copy current reports into semantic report folders.
targets = {
    "hardware-report.md": a.assets/"reports/hardware/device-hardware-latest.md",
    "software-report.md": a.assets/"reports/software/android-software-latest.md",
    "partition-report.md": a.assets/"reports/partitions/partition-map-latest.md",
    "security-report.md": a.assets/"reports/security/security-posture-latest.md",
    "performance-baseline.md": a.assets/"reports/performance/performance-baseline-latest.md",
    "validation-report.md": a.assets/"reports/validation/collection-validation-latest.md",
}
for src_name, dst in targets.items():
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(a.reports/src_name, dst)

index = f"""# Device Collection — {a.run_id}

- [Hardware report](hardware-report.md)
- [Software report](software-report.md)
- [Partition report](partition-report.md)
- [Security report](security-report.md)
- [Performance baseline](performance-baseline.md)
- [Validation report](validation-report.md)
"""
(a.reports/"README.md").write_text(index, encoding="utf-8")
