---
title: "Backup Strategy"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Backup Strategy

> *"The safest firmware modification is the one that can always be undone. Every successful ROM engineering project begins with a complete and verified backup."*

---

# Introduction

The previous volumes focused on understanding the HY300 firmware architecture and identifying the proprietary software responsible for projector-specific functionality.

Beginning with Volume 4, the investigation shifts from analysis to implementation.

Before modifying a single partition, APK, or configuration file, a complete backup strategy must be established.

Firmware engineering should always assume that an experiment may fail.

A verified backup provides the ability to recover from unexpected behavior, compare firmware revisions, validate reconstruction efforts, and preserve the original state of the device.

---

# Objectives

This chapter aims to:

- define a reliable backup strategy;
- identify critical partitions;
- distinguish logical and physical backups;
- document integrity verification;
- establish recovery procedures;
- create a reproducible engineering workflow.

No firmware modifications are performed in this chapter.

---

# Why Backups Matter

Firmware development involves modifying low-level system components.

Potential risks include:

- boot loops;
- corrupted partitions;
- failed OTA updates;
- incompatible libraries;
- accidental file deletion;
- invalid filesystem images.

Without verified backups, recovery may require obtaining a complete firmware image from external sources—or may not be possible at all.

---

# Engineering Philosophy

The project follows a simple rule:

```text
Backup

↓

Verify

↓

Document

↓

Modify

↓

Validate

↓

Release
```

Every engineering action begins with preserving the original firmware.

---

# What Should Be Backed Up?

The minimum recommended backup includes:

| Component                   | Purpose                       |
| --------------------------- | ----------------------------- |
| `boot.img`                  | Kernel and ramdisk            |
| `vbmeta.img`                | Verified Boot metadata        |
| `super.img`                 | Dynamic partitions            |
| `recovery.img` (if present) | Recovery environment          |
| OEM APKs                    | Application restoration       |
| Configuration files         | Device settings               |
| Native libraries            | Reverse engineering reference |

Together, these components represent the complete software state of the device.

---

# Backup Types

The project distinguishes three categories of backups.

## Raw Images

Examples:

```text
boot.img

super.img

vbmeta.img
```

These are exact binary copies.

---

## Extracted Filesystems

Examples:

```text
system/

vendor/

product/

odm/
```

Useful for:

- code analysis;
- APK replacement;
- configuration editing.

---

## Project Repository

Engineering artifacts include:

```text
scripts/

documentation/

patches/

hashes/

notes/
```

These files ensure that the reconstruction process remains reproducible.

---

# Recommended Directory Structure

```text
HY300-Project/

├── backups/
│   ├── original/
│   ├── extracted/
│   └── modified/
│
├── firmware/
│
├── tools/
│
├── scripts/
│
├── hashes/
│
├── docs/
│
└── releases/
```

Separating original and modified files prevents accidental overwriting.

---

# Dumping Partitions

Depending on the available access method, partitions can be extracted using tools such as:

```bash
adb pull
```

or

```bash
dd
```

Example:

```bash
adb shell dd if=/dev/block/by-name/boot of=/sdcard/boot.img
```

The resulting image can then be copied to the workstation.

---

# Preserving APKs

OEM applications should be copied before modification.

Example:

```bash
adb pull /system/app/

adb pull /system/priv-app/

adb pull /product/app/
```

Maintaining original APKs simplifies later comparisons and restoration.

---

# Recording Device Information

A firmware backup should always include system metadata.

Useful commands:

```bash
adb shell getprop
```

```bash
adb shell uname -a
```

```bash
adb shell cat /proc/version
```

```bash
adb shell cat /proc/cpuinfo
```

These outputs provide valuable context for future analysis.

---

# Integrity Verification

Every backup should be verified immediately after creation.

Generate SHA-256 hashes:

```bash
sha256sum boot.img

sha256sum super.img

sha256sum vbmeta.img
```

Example output:

```text
4d6b4d4b...

boot.img
```

Hashes ensure that backup files remain unchanged throughout the project.

---

# Backup Workflow

```text
Extract Image

↓

Calculate SHA-256

↓

Store Hash

↓

Copy to Backup Repository

↓

Verify Copy

↓

Archive
```

Every backup should follow the same repeatable process.

---

# Multiple Backup Copies

The project maintains several independent copies.

```text
Original Device

↓

Primary Backup

↓

Offline Archive

↓

Cloud Archive (optional)

↓

Working Copy
```

Only the working copy is modified.

The original backup remains untouched.

---

# Version Control

Binary images should never replace previous versions.

Recommended naming convention:

```text
boot-original.img

boot-v01.img

boot-v02.img
```

Likewise:

```text
super-original.img

super-v01.img

super-v02.img
```

This approach preserves the complete engineering history.

---

# Documentation

Every backup operation should be documented.

Suggested information includes:

| Item             | Example        |
| ---------------- | -------------- |
| Date             | 2026-07-14     |
| Device           | HY300          |
| Firmware Version | Recorded       |
| Operator         | Research Log   |
| SHA-256          | Recorded       |
| Notes            | Initial backup |

Documentation improves reproducibility and collaboration.

---

# Common Mistakes

Typical backup mistakes include:

- modifying original images;
- failing to verify hashes;
- mixing original and modified files;
- overwriting previous backups;
- incomplete partition dumps;
- missing configuration files.

Most of these issues are easily avoided through consistent procedures.

---

# Reverse Engineering Workflow

The project follows this workflow before any firmware modification.

```text
Identify Firmware

↓

Extract Partitions

↓

Verify Hashes

↓

Archive Originals

↓

Extract Filesystems

↓

Document Environment

↓

Begin Engineering
```

This ensures that every modification remains reversible.

---

# Engineering Observations

Several lessons emerged during the project.

- Backups consume little time compared to firmware recovery.
- Hash verification detects accidental corruption.
- Documentation is as important as binary preservation.
- Multiple backup copies greatly reduce project risk.
- Original images should remain read-only whenever possible.

---

# Best Practices

When creating firmware backups:

- Preserve original images permanently.
- Verify every backup with SHA-256.
- Separate original and working copies.
- Document firmware versions.
- Archive APKs and configuration files.
- Never begin modification without confirming backup integrity.

---

# Summary

A reliable backup strategy forms the foundation of every firmware engineering project.

By preserving original partitions, recording system metadata, verifying file integrity, and maintaining multiple independent copies, the HY300 Ultimate project ensured that every modification remained reversible and fully traceable.

This disciplined approach significantly reduced engineering risk while providing a dependable reference throughout the reconstruction process.

---

# Next Chapter

With a complete backup strategy established, the next chapter explains how to create **partition dumps** from the device.

Topics include:

- partition extraction;
- `dd`;
- ADB-based dumping;
- block devices;
- image verification;
- storage organization.

These partition images become the primary working material for the remainder of the ROM reconstruction process.

---

> [!IMPORTANT]
> Backups are not merely a safety measure—they are part of the engineering process itself. A firmware image without a verified backup cannot be considered reproducible, and any modification performed without preserving the original state increases both technical risk and debugging complexity.