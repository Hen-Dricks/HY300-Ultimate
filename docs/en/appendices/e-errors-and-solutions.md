---
title: "Appendix E — Errors and Solutions"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "en"
last_updated: "2026-07-14"
---

# Appendix E — Errors and Solutions

> *"A documented error becomes knowledge. An undocumented error is likely to happen again."*

---

# Purpose

This appendix serves as the troubleshooting reference for the HY300 Ultimate project.

It documents the most common issues encountered during:

- firmware extraction;
- partition analysis;
- filesystem modification;
- image reconstruction;
- flashing;
- validation;
- Docker development.

Each issue is presented using the same methodology:

```text
Symptom

↓

Possible Causes

↓

Diagnosis

↓

Resolution

↓

Prevention
```

Following a consistent troubleshooting process significantly reduces debugging time and improves reproducibility.

---

# 1. ADB Does Not Detect the Device

## Symptom

```text
List of devices attached

(no devices)
```

## Possible Causes

- Faulty USB cable
- USB debugging disabled
- Device authorization not accepted
- ADB server not running
- Incorrect USB mode

## Diagnosis

```bash
adb devices

adb kill-server

adb start-server
```

## Resolution

```bash
adb kill-server
adb start-server
adb devices
```

Reconnect the USB cable and accept the debugging authorization prompt if displayed.

## Prevention

Always verify the ADB connection before starting any firmware operation.

---

# 2. Unable to Mount an ext4 Image

## Symptom

```text
mount: wrong filesystem type
```

## Possible Causes

- Sparse image
- Corrupted filesystem
- Invalid image
- Unsupported filesystem

## Diagnosis

```bash
file system.img
```

```bash
e2fsck -f system.img
```

## Resolution

Convert the sparse image to raw format.

```bash
simg2img system.img system.raw.img
```

Then mount the raw image.

## Prevention

Always identify the image type before mounting.

---

# 3. ext4 Filesystem Errors

## Symptom

```text
Filesystem errors found
```

## Diagnosis

```bash
e2fsck -f system.raw.img
```

## Resolution

```bash
e2fsck -fy system.raw.img
```

Run a second verification afterwards.

## Prevention

Always unmount filesystem images properly before rebuilding them.

---

# 4. lpunpack Fails

## Symptom

```text
Unable to parse metadata
```

## Possible Causes

- Corrupted image
- Incomplete firmware dump
- Unsupported LP metadata

## Diagnosis

```bash
sha256sum super.img

file super.img
```

```bash
lpdump super.img
```

## Resolution

Verify the image integrity and compare it against the original firmware backup.

## Prevention

Calculate SHA-256 immediately after extracting every firmware image.

---

# 5. lpmake Fails

## Symptom

```text
Partition does not fit
```

## Possible Causes

- Partition exceeds available space
- Incorrect LP group configuration
- Invalid partition sizes

## Diagnosis

Verify:

- partition sizes;
- LP metadata;
- command parameters.

## Resolution

Reduce the filesystem size.

```bash
resize2fs
```

Rebuild the image afterwards.

## Prevention

Validate every partition size before rebuilding `super.img`.

---

# 6. Bootloop After Flashing

## Symptom

The device continuously reboots.

## Possible Causes

- Corrupted partition
- Missing system component
- Invalid boot image
- Incorrect firmware reconstruction

## Diagnosis

Collect logs whenever possible.

```bash
adb logcat

adb shell dmesg
```

Inspect tombstones if available.

## Resolution

Restore the last known working firmware.

## Prevention

Apply only one modification between validation cycles.

---

# 7. Docker Does Not Start

## Symptom

```text
Cannot connect to the Docker daemon
```

## Diagnosis

```bash
docker info
```

## Resolution

Start Docker Desktop or the Docker daemon.

## Prevention

Verify Docker before launching any build.

---

# 8. Git Merge Conflict

## Symptom

```text
Merge conflict
```

## Diagnosis

```bash
git status
```

## Resolution

Resolve every conflicting file before committing.

## Prevention

Create small, focused commits instead of large batches of unrelated changes.

---

# 9. Permission Denied

## Symptom

```text
Permission denied
```

## Diagnosis

```bash
ls -l
```

## Resolution

```bash
chmod +x script.sh
```

or

```bash
sudo chown
```

depending on the situation.

## Prevention

Maintain consistent permissions throughout the project.

---

# 10. SHA-256 Verification Failed

## Symptom

```text
FAILED
```

after running

```bash
sha256sum -c SHA256SUMS
```

## Possible Causes

- File corruption
- Modified artifact
- Incomplete download
- Incorrect firmware version

## Diagnosis

Compare:

- file size;
- modification date;
- origin;
- expected hash.

## Resolution

Replace the corrupted artifact with a verified copy.

## Prevention

Verify SHA-256 after every important transfer.

---

# 11. OTA Update Fails

## Symptom

The OTA package is rejected or installation stops unexpectedly.

## Possible Causes

- Modified partitions
- Signature verification failure
- Version mismatch
- Integrity verification failure

## Diagnosis

Review OTA logs.

```bash
adb logcat
```

Inspect package metadata if available.

## Resolution

Restore the expected firmware state before attempting the update again.

## Prevention

Understand the OTA validation process before modifying system partitions.

---

# 12. Recovery Cannot Mount a Partition

## Symptom

Recovery reports mount failures.

## Possible Causes

- Filesystem corruption
- Incorrect partition table
- Invalid image

## Diagnosis

Run filesystem verification.

```bash
e2fsck
```

Inspect partition metadata.

## Resolution

Repair or restore the affected partition.

## Prevention

Always validate images before flashing.

---

# Quick Troubleshooting Table

| Symptom                   | Recommended Command |
| ------------------------- | ------------------- |
| ADB unavailable           | `adb devices`       |
| Image cannot be mounted   | `file`              |
| ext4 errors               | `e2fsck`            |
| Incorrect filesystem size | `resize2fs`         |
| Dynamic partition issues  | `lpmake` / `lpdump` |
| Bootloop                  | `logcat` / `dmesg`  |
| Docker failure            | `docker info`       |
| Git conflict              | `git status`        |
| Permission error          | `ls -l`             |
| Hash mismatch             | `sha256sum -c`      |

---

# Recommended Troubleshooting Workflow

```text
Identify the symptom

↓

Preserve logs

↓

Verify hashes

↓

Inspect filesystem

↓

Test one hypothesis

↓

Apply one correction

↓

Validate

↓

Document the result
```

Changing multiple parameters simultaneously makes root-cause analysis significantly more difficult.

---

# Incident Log

Every significant issue encountered during development should be documented.

| Date            | Issue | Root Cause | Resolution | Status |
| --------------- | ----- | ---------- | ---------- | :----: |
| To be completed |       |            |            |        |

Maintaining an incident history greatly improves long-term maintainability and knowledge sharing.

---

# Best Practices

- Preserve logs before making changes.
- Modify one variable at a time.
- Keep verified backups.
- Record every command executed.
- Update this appendix whenever a new issue is identified.
- Distinguish confirmed root causes from working hypotheses.

---

# HY300 Ultimate Incident Reports

Major incidents should also be documented individually.

Recommended location:

```text
research/incidents/

INCIDENT-001.md
INCIDENT-002.md
INCIDENT-003.md
...
```

Each report should include:

- context;
- symptoms;
- impact;
- diagnosis;
- root cause;
- corrective action;
- preventive measures.

This creates a searchable knowledge base for future contributors.

---

> [!TIP]
> Resist the temptation to "fix everything at once." The fastest way to solve a complex firmware issue is usually the most disciplined one: isolate a single variable, validate the result, document the outcome, and only then move on to the next change.