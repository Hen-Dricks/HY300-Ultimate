---
title: "Modifying system.img"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Modifying system.img

> *"Extracting a filesystem is only the beginning. Engineering a custom ROM requires making controlled, reversible, and fully documented modifications while preserving filesystem integrity."*

---

# Introduction

After extracting the logical partitions from `super.img`, the next stage of the reconstruction process consists of modifying the Android system partition.

Among all extracted images, `system.img` contains the core operating system, including:

- Android framework components;
- system applications;
- shared libraries;
- fonts;
- media assets;
- configuration files.

Because virtually every application depends on this partition, modifications must be performed carefully and validated before rebuilding the firmware.

Throughout the HY300 Ultimate project, every modification followed a disciplined engineering workflow designed to maximize reproducibility while minimizing the risk of filesystem corruption.

---

# Objectives

This chapter aims to:

- prepare `system.img` for modification;
- explain safe filesystem editing;
- document APK replacement;
- describe configuration management;
- preserve filesystem integrity;
- establish validation procedures.

The focus is on methodology rather than any specific firmware customization.

---

# Engineering Workflow

The modification process follows a structured sequence.

```text
Extract system.img

↓

Verify ext4

↓

Mount Filesystem

↓

Modify Files

↓

Verify Integrity

↓

Unmount

↓

Generate Updated Image

↓

Validation
```

Each stage is completed before moving to the next.

---

# Preparing the Filesystem

Before editing the image:

Verify filesystem integrity.

```bash
e2fsck -f system.img
```

Inspect filesystem information.

```bash
tune2fs -l system.img
```

These checks establish a known-good starting point.

---

# Mounting system.img

Create a mount directory.

```bash
mkdir system_mount
```

Mount the image.

```bash
sudo mount -o loop system.img system_mount
```

The mounted directory now reflects the Android filesystem exactly as it will appear on the device.

---

# Typical Directory Layout

```text
system/

├── app/
├── priv-app/
├── bin/
├── etc/
├── framework/
├── fonts/
├── lib/
├── lib64/
├── media/
└── usr/
```

Each directory serves a different role within Android.

---

# Typical Modifications

Common engineering tasks include:

- replacing system APKs;
- updating configuration files;
- removing unused resources;
- adding custom applications;
- replacing media assets;
- updating certificates (where appropriate);
- documenting filesystem changes.

Each modification should be recorded independently.

---

# APK Replacement

Applications generally reside in:

```text
system/app/

system/priv-app/
```

Typical workflow:

```text
Original APK

↓

Backup

↓

Replacement APK

↓

Permission Verification

↓

Filesystem Validation
```

Original files should never be discarded.

---

# Configuration Files

Configuration typically resides in:

```text
system/etc/
```

Examples include:

- XML configuration;
- permission declarations;
- default properties;
- service definitions.

Configuration changes should remain as small and well-documented as possible.

---

# Shared Libraries

Native libraries are commonly located in:

```text
system/lib/

system/lib64/
```

Before replacing a library:

- record its version;
- calculate its SHA-256 hash;
- document dependencies.

Library replacement requires careful compatibility verification.

---

# File Permissions

Android depends on correct filesystem permissions.

Typical inspection:

```bash
ls -la
```

Preserving ownership and permissions is essential when replacing files.

Unexpected permission changes may prevent Android components from functioning correctly.

---

# Filesystem Capacity

After modifications:

```bash
df -h
```

The available space should be monitored throughout the engineering process.

Unexpected filesystem growth may later complicate partition rebuilding.

---

# Integrity Verification

After completing modifications:

```bash
e2fsck -f system.img
```

Filesystem consistency should always be verified before rebuilding.

---

# Hash Verification

Generate an updated checksum.

```bash
sha256sum system.img
```

Recommended naming:

```text
system-original.img

system-v01.img

system-v02.img
```

Every revision should receive its own checksum.

---

# Documentation

Each modification should be logged.

Example table:

| Item           | Description        |
| -------------- | ------------------ |
| Date           | Modification date  |
| Image          | `system.img`       |
| Files Changed  | Recorded           |
| Hash           | SHA-256            |
| Engineer Notes | Summary of changes |

Comprehensive documentation simplifies debugging and future maintenance.

---

# Reverse Engineering Workflow

The HY300 Ultimate project adopted the following workflow.

```text
Verify Image

↓

Mount Filesystem

↓

Backup Original Files

↓

Modify

↓

Verify Permissions

↓

Check Filesystem

↓

Generate Hash

↓

Archive
```

Every engineering iteration followed the same repeatable process.

---

# Engineering Observations

Several practical lessons emerged.

- Small incremental changes simplify troubleshooting.
- Original files should always remain recoverable.
- Filesystem verification detects issues early.
- Documentation reduces engineering mistakes.
- Hash verification provides reliable version tracking.

---

# Common Mistakes

Typical mistakes include:

- modifying the original image directly;
- forgetting filesystem verification;
- incorrect file permissions;
- replacing incompatible libraries;
- removing undocumented components;
- failing to archive previous revisions.

Most issues can be avoided through disciplined engineering practices.

---

# Best Practices

When modifying `system.img`:

- Preserve immutable backups.
- Work on copied images only.
- Verify ext4 integrity after every session.
- Record every modification.
- Validate permissions before rebuilding.
- Generate hashes for every revision.

---

# Summary

Modifying `system.img` is one of the central tasks of Android ROM engineering.

By mounting the filesystem safely, preserving original files, validating every modification, and maintaining complete documentation, the HY300 Ultimate project ensured that firmware customization remained reproducible, reversible, and technically reliable.

---

# Next Chapter

With the system image prepared for customization, the next chapter examines one of the project's most significant engineering decisions:

the removal of **daemon12138** from the custom firmware.

The discussion focuses on dependency analysis, validation methodology, and controlled experimentation rather than implementation details.

---

> [!IMPORTANT]
> A successful ROM modification is measured not by the number of files changed, but by the reproducibility of the engineering process. Every change should be deliberate, documented, reversible, and validated before the firmware is rebuilt.