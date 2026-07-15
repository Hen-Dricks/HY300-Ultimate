---
title: "Docker and ext4 Filesystem Engineering"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Docker and ext4 Filesystem Engineering

> *"A reproducible engineering environment is just as important as the firmware itself. Docker guarantees consistency, while ext4 provides direct access to Android's filesystem."*

---

# Introduction

After acquiring verified partition dumps, the next step is preparing a controlled environment for firmware modification.

Throughout the HY300 Ultimate project, firmware reconstruction was intentionally performed **outside the target device**, inside an isolated Linux environment.

This approach provides several advantages:

- reproducibility;
- safety;
- portability;
- dependency isolation;
- consistent tooling.

Docker containers and Linux filesystem utilities became the foundation of the ROM reconstruction workflow.

---

# Objectives

This chapter aims to:

- explain why Docker was selected;
- introduce ext4 filesystem manipulation;
- establish a reproducible engineering environment;
- document safe image editing procedures;
- prepare the workspace for firmware reconstruction.

No firmware images are modified during this chapter.

---

# Why Docker?

Firmware engineering often requires:

- Linux-specific utilities;
- filesystem drivers;
- Android image tools;
- build dependencies;
- scripting environments.

Installing these directly on the host operating system introduces unnecessary complexity.

Docker isolates these dependencies inside reproducible containers.

---

# Engineering Workflow

The overall workflow is shown below.

```text
Partition Dump

↓

Docker Container

↓

Filesystem Mount

↓

Image Modification

↓

Filesystem Verification

↓

Rebuild Image

↓

Validation
```

Every firmware modification occurs inside the container.

---

# Advantages of Docker

Docker offers several important benefits.

| Advantage       | Benefit                                |
| --------------- | -------------------------------------- |
| Isolation       | Protects the host system               |
| Reproducibility | Same environment on every workstation  |
| Portability     | Works across Linux, macOS, and Windows |
| Version Control | Toolchain remains consistent           |
| Automation      | Easy scripting and CI integration      |

These characteristics greatly simplify collaborative firmware engineering.

---

# Recommended Container Layout

```text
Docker Container

├── firmware/
├── images/
├── extracted/
├── scripts/
├── tools/
├── output/
└── hashes/
```

Separating original images from generated artifacts minimizes accidental modifications.

---

# Why ext4?

Most Android partitions use the **ext4 filesystem**.

Examples include:

- system
- vendor
- product
- odm
- userdata

Understanding ext4 is therefore essential before modifying Android images.

---

# ext4 Overview

Simplified structure:

```text
ext4 Filesystem

├── Superblock
├── Block Groups
├── Inodes
├── Directories
├── Files
└── Journaling Metadata
```

Unlike simply extracting files, modifying an ext4 image requires preserving its internal filesystem integrity.

---

# Typical Engineering Process

```text
Original Image

↓

Mount ext4

↓

Modify Files

↓

Verify Filesystem

↓

Unmount

↓

Generate New Image
```

At no point is the original image modified directly.

---

# Mounting an Image

Typical Linux workflow:

```bash
mkdir system_mount
```

```bash
sudo mount -o loop system.img system_mount
```

The mounted directory exposes the filesystem exactly as Android sees it.

---

# Read-Only Mounts

During analysis, read-only mounts are preferred.

Example:

```bash
sudo mount -o ro,loop system.img system_mount
```

Benefits include:

- preventing accidental modification;
- preserving forensic integrity;
- simplifying comparisons.

Writable mounts should only be used during planned reconstruction.

---

# Filesystem Inspection

Useful commands include:

Display disk usage:

```bash
df -h
```

Inspect directories:

```bash
ls -la
```

Display filesystem information:

```bash
dumpe2fs system.img
```

Inspect filesystem metadata:

```bash
tune2fs -l system.img
```

These commands reveal valuable structural information without altering the image.

---

# Filesystem Verification

Before rebuilding an image, ext4 integrity should be verified.

Typical command:

```bash
e2fsck -f system.img
```

Possible results include:

- clean filesystem;
- orphaned inode;
- allocation inconsistency;
- journal recovery.

Filesystem verification should always precede image reconstruction.

---

# Resizing ext4 Images

Some modifications require additional filesystem space.

Example:

```bash
resize2fs system.img
```

Resizing should always be planned carefully because filesystem size directly affects partition reconstruction.

---

# Docker Workflow

Typical engineering cycle:

```text
Host Computer

↓

Docker Container

↓

Mounted ext4 Image

↓

APK Replacement

↓

Library Modification

↓

Filesystem Verification

↓

Unmount

↓

Rebuild
```

This approach keeps the host operating system untouched.

---

# Working with Multiple Images

A typical project contains several mounted images simultaneously.

```text
workspace/

├── system/
├── vendor/
├── product/
├── odm/
└── output/
```

Maintaining a clear directory structure simplifies dependency tracking.

---

# Integrity Verification

After every modification:

```text
Filesystem Check

↓

Calculate SHA-256

↓

Compare with Previous Version

↓

Archive
```

Integrity verification remains a recurring step throughout the reconstruction process.

---

# Reverse Engineering Workflow

The project adopted the following methodology.

```text
Create Docker Environment

↓

Mount ext4 Image

↓

Inspect Filesystem

↓

Perform Modification

↓

Verify ext4 Integrity

↓

Unmount

↓

Generate New Image
```

Each stage was documented before proceeding to the next.

---

# Engineering Observations

Several practical lessons emerged.

- Docker significantly reduced environment-related issues.
- ext4 verification prevented corrupted filesystem images.
- Read-only mounts were invaluable during analysis.
- Consistent directory structures improved productivity.
- Image verification reduced debugging time later in the workflow.

---

# Common Challenges

Typical issues encountered include:

- insufficient filesystem space;
- mount permission errors;
- loop device conflicts;
- filesystem corruption;
- inconsistent Docker volumes;
- host operating system differences.

Most problems can be avoided through careful preparation and repeatable workflows.

---

# Best Practices

When working with Docker and ext4:

- Never mount original images read-write.
- Perform all modifications inside containers.
- Verify ext4 integrity after every change.
- Preserve immutable backup images.
- Document container versions.
- Maintain a clean workspace structure.

---

# Summary

Docker and ext4 together provide the technical foundation for safe Android firmware reconstruction.

Docker ensures a reproducible engineering environment, while ext4 tools allow direct access to Android filesystem images without modifying the original firmware.

This combination enables controlled experimentation, reliable validation, and repeatable ROM engineering workflows.

---

# Next Chapter

With the engineering environment fully prepared, the next chapter examines one of Android's most important firmware structures:

**super.img**.

Topics include:

- dynamic partition layout;
- LP metadata;
- `lpunpack`;
- logical partition extraction;
- filesystem organization;
- preparation for image modification.

This marks the beginning of direct interaction with Android's dynamic partition system.

---

> [!IMPORTANT]
> Firmware reconstruction should always take place inside a controlled and reproducible environment. Docker provides consistent tooling across systems, while careful handling of ext4 images ensures that every modification preserves filesystem integrity and remains fully traceable.