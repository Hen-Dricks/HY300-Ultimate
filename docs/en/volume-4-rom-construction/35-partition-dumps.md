---
title: "Partition Dumps"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Partition Dumps

> *"Before rebuilding a firmware, every partition must first be preserved exactly as it exists on the device. A reliable partition dump is the starting point of every reproducible ROM engineering project."*

---

# Introduction

After defining a comprehensive backup strategy, the next step is acquiring exact binary copies of the device's partitions.

These copies—commonly called **partition dumps**—serve as the primary source material for reverse engineering, firmware reconstruction, and validation.

Unlike extracted files or APKs, partition dumps preserve the filesystem exactly as stored on the flash memory, including metadata, alignment, and filesystem structures.

Throughout the HY300 Ultimate project, every firmware modification originated from verified partition dumps rather than directly editing a running device.

---

# Objectives

This chapter aims to:

- explain what partition dumps are;
- identify important Android partitions;
- document safe dumping methods;
- verify dump integrity;
- organize extracted images;
- establish reproducible acquisition procedures.

No partition modifications are performed during this chapter.

---

# What Is a Partition Dump?

A partition dump is a binary image containing the exact contents of a storage partition.

Example:

```text
boot.img

vendor.img

super.img

vbmeta.img
```

Unlike filesystem copies, these images preserve:

- filesystem metadata;
- partition layout;
- binary alignment;
- unused sectors;
- original structure.

---

# Why Dump Partitions?

Partition dumps provide several advantages.

They allow engineers to:

- reconstruct firmware;
- compare firmware revisions;
- recover corrupted images;
- inspect filesystems offline;
- calculate hashes;
- reproduce experiments.

A dump is therefore the most reliable representation of a device's software state.

---

# Android Partition Layout

A simplified partition layout:

```text
Flash Storage

├── boot
├── vbmeta
├── super
├── metadata
├── misc
├── userdata
└── recovery (if present)
```

Depending on the device, additional vendor-specific partitions may also exist.

---

# Identifying Partitions

List block devices:

```bash
adb shell ls -l /dev/block/by-name
```

Alternatively:

```bash
adb shell cat /proc/partitions
```

These commands reveal the partition names recognized by Android.

---

# Dumping with `dd`

The standard Linux tool for creating raw images is:

```bash
dd
```

Example:

```bash
adb shell dd if=/dev/block/by-name/boot \
of=/sdcard/boot.img
```

Explanation:

- `if` → input file
- `of` → output file

The resulting image is an exact binary copy.

---

# Copying the Dump

Once created:

```bash
adb pull /sdcard/boot.img
```

The image is transferred from the device to the workstation.

---

# Dumping Multiple Partitions

Typical workflow:

```bash
boot

↓

vbmeta

↓

super

↓

metadata

↓

vendor_boot (if present)

↓

recovery
```

Each image should be dumped independently.

---

# Using Block Devices Directly

Android partitions are exposed through:

```text
/dev/block/by-name/
```

Example:

```text
boot

↓

/dev/block/by-name/boot
```

This symbolic structure simplifies partition identification.

---

# Verifying Dump Size

After extraction:

```bash
ls -lh *.img
```

Unexpected file sizes may indicate:

- incomplete dumps;
- wrong partition selection;
- storage errors.

File size verification is therefore an important first check.

---

# Calculating Hashes

Every image should immediately receive a SHA-256 checksum.

```bash
sha256sum boot.img

sha256sum vbmeta.img

sha256sum super.img
```

Hashes should be stored separately from the images.

---

# Comparing Dumps

Multiple dumps can be compared using:

```bash
sha256sum
```

or

```bash
cmp image1.img image2.img
```

If two images produce identical hashes, they are identical bit-for-bit.

---

# Dump Organization

Recommended structure:

```text
partition-dumps/

├── original/
│   ├── boot.img
│   ├── super.img
│   ├── vbmeta.img
│   └── metadata.img
│
├── modified/
│
└── hashes/
```

This separation avoids accidental modification of original images.

---

# Integrity Workflow

```text
Dump Partition

↓

Transfer Image

↓

Verify Size

↓

Calculate SHA-256

↓

Archive Original

↓

Create Working Copy
```

Only the working copy should ever be modified.

---

# Common Dump Commands

Display partitions:

```bash
adb shell ls -l /dev/block/by-name
```

Create dump:

```bash
adb shell dd if=/dev/block/by-name/system \
of=/sdcard/system.img
```

Transfer image:

```bash
adb pull /sdcard/system.img
```

Verify hash:

```bash
sha256sum system.img
```

These commands formed the basis of the partition acquisition workflow throughout the project.

---

# Reverse Engineering Workflow

The HY300 investigation followed this methodology.

```text
Identify Partition

↓

Dump Image

↓

Transfer to Workstation

↓

Verify Integrity

↓

Archive Original

↓

Begin Analysis
```

Every partition followed the same repeatable process.

---

# Engineering Considerations

Several practical lessons emerged.

- Dump partitions before making any changes.
- Verify hashes immediately.
- Preserve original filenames.
- Record firmware version alongside dumps.
- Never overwrite original images.

These practices significantly reduce engineering errors.

---

# Common Mistakes

Typical mistakes include:

- dumping the wrong partition;
- interrupting the dump process;
- modifying the original image;
- forgetting integrity verification;
- storing images without documentation;
- confusing logical and physical partitions.

A disciplined workflow prevents nearly all of these issues.

---

# Best Practices

When creating partition dumps:

- Use raw binary images.
- Verify every file with SHA-256.
- Preserve the original dump permanently.
- Keep detailed acquisition notes.
- Separate backups from working copies.
- Repeat dumps if corruption is suspected.

---

# Summary

Partition dumps provide the raw foundation upon which every firmware reconstruction project is built.

By extracting exact binary images, verifying their integrity, and preserving them as immutable references, the HY300 Ultimate project established a reproducible workflow for reverse engineering and ROM customization.

These images become the primary source material for filesystem extraction, partition rebuilding, and firmware validation.

---

# Next Chapter

With verified partition dumps available, the next chapter introduces the engineering environment used throughout the project.

Topics include:

- Docker
- Linux containers
- ext4 filesystem tools
- reproducible build environments
- image mounting
- filesystem manipulation

These tools enable safe firmware modification without altering the original partition images.

---

> [!IMPORTANT]
> A partition dump is more than a backup—it is a forensic snapshot of the firmware at a specific point in time. Every subsequent modification, comparison, and validation performed during ROM reconstruction depends on the accuracy and integrity of these original images.