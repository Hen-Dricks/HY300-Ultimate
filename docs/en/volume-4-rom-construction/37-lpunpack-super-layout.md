---
title: "Extracting Dynamic Partitions with lpunpack"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Extracting Dynamic Partitions with lpunpack

> *"Modern Android devices no longer store system partitions independently. Instead, they are assembled dynamically from a single container: `super.img`."*

---

# Introduction

After establishing a reproducible engineering environment with Docker and ext4 tools, the next step in firmware reconstruction is understanding Android's **dynamic partition container**.

Unlike older Android devices, the HY300 firmware stores multiple logical partitions inside a single image:

```text
super.img
```

Before any filesystem can be modified, these logical partitions must first be extracted.

The primary tool used throughout this project is:

```text
lpunpack
```

This chapter explains the structure of `super.img`, the role of Logical Partition (LP) metadata, and the extraction workflow adopted during the HY300 Ultimate project.

---

# Objectives

This chapter aims to:

- explain the architecture of `super.img`;
- introduce Android dynamic partitions;
- describe LP metadata;
- demonstrate the use of `lpunpack`;
- document partition extraction;
- prepare images for modification.

No firmware images are modified during this chapter.

---

# Why Dynamic Partitions?

Beginning with Android 10, Google introduced **Dynamic Partitions**.

Instead of allocating fixed storage areas:

```text
system.img

vendor.img

product.img
```

Android groups them inside a single logical container.

Benefits include:

- improved storage utilization;
- flexible partition sizing;
- easier OTA updates;
- simplified firmware maintenance.

---

# Simplified Layout

```text
Flash Storage

↓

super.img

├── LP Metadata
├── system
├── vendor
├── product
├── odm
└── Reserved Space
```

The operating system reconstructs these logical partitions during boot using Device Mapper.

---

# LP Metadata

The first structure inside `super.img` is the **Logical Partition Metadata**.

It contains information such as:

- partition names;
- logical sizes;
- extents;
- block mappings;
- partition groups;
- allocation tables.

The metadata itself contains no filesystem.

Instead, it describes where each logical partition resides.

---

# Inspecting the Layout

The partition layout can be examined using:

```bash
lpdump super.img
```

Typical output includes:

- metadata version;
- partition list;
- partition sizes;
- block allocation;
- group information.

This information should always be documented before extraction.

---

# Simplified Architecture

```text
super.img

↓

LP Metadata

↓

Logical Partition Table

↓

system

vendor

product

odm
```

Each logical partition behaves like an independent filesystem after extraction.

---

# What is lpunpack?

`lpunpack` is part of Android's Logical Partition tools.

Its purpose is to extract individual logical partitions from `super.img`.

Simplified workflow:

```text
super.img

↓

lpunpack

↓

system.img

vendor.img

product.img

odm.img
```

Each output image can then be mounted independently.

---

# Basic Usage

Typical command:

```bash
lpunpack super.img output/
```

The resulting directory contains:

```text
output/

├── system.img
├── vendor.img
├── product.img
└── odm.img
```

Partition availability depends on the firmware.

---

# Verifying the Extraction

After extraction:

```bash
ls -lh output/
```

Each filesystem image should have:

- expected size;
- valid ext4 filesystem;
- consistent metadata.

Filesystem integrity can then be verified using:

```bash
e2fsck
```

---

# Extraction Workflow

```text
super.img

↓

lpdump

↓

Verify Metadata

↓

lpunpack

↓

Extract Logical Images

↓

Verify ext4

↓

Mount Filesystems
```

This sequence was followed consistently throughout the project.

---

# Relationship with Device Mapper

During runtime:

```text
super.img

↓

LP Metadata

↓

Device Mapper

↓

dm-0

↓

system
```

During offline reconstruction:

```text
super.img

↓

lpunpack

↓

system.img
```

Offline extraction eliminates the need for Device Mapper.

---

# Working Directory

Recommended structure:

```text
workspace/

├── super.img

├── extracted/
│   ├── system.img
│   ├── vendor.img
│   ├── product.img
│   └── odm.img

├── mounted/

└── rebuilt/
```

A structured workspace simplifies later rebuilding.

---

# Integrity Verification

After extraction:

Generate hashes:

```bash
sha256sum extracted/*.img
```

Inspect filesystem:

```bash
file extracted/system.img
```

Verify ext4:

```bash
e2fsck -f extracted/system.img
```

These checks ensure that extraction completed successfully.

---

# Common Problems

Typical issues include:

| Problem                   | Possible Cause                    |
| ------------------------- | --------------------------------- |
| Missing partition         | Firmware variant                  |
| Invalid metadata          | Corrupted `super.img`             |
| Mount failure             | Damaged ext4 filesystem           |
| Unexpected partition size | Incorrect metadata interpretation |
| Extraction failure        | Unsupported LP version            |

Proper verification usually identifies these issues early.

---

# Reverse Engineering Workflow

The HY300 Ultimate project followed this methodology.

```text
Obtain super.img

↓

Inspect LP Metadata

↓

Extract Partitions

↓

Verify Images

↓

Mount Filesystems

↓

Document Structure

↓

Begin Modification
```

Every extracted image remained identical to its original counterpart until modification began.

---

# Engineering Observations

Several observations emerged.

- Dynamic partitions greatly simplify OTA updates.
- LP metadata is as important as the filesystems themselves.
- `lpunpack` preserves logical partition boundaries.
- Filesystem verification should immediately follow extraction.
- Consistent directory organization reduces engineering mistakes.

---

# Best Practices

When working with `super.img`:

- Preserve the original image.
- Document LP metadata before extraction.
- Verify every extracted filesystem.
- Generate SHA-256 hashes.
- Maintain separate original and working directories.
- Never modify extracted images before creating verified backups.

---

# Summary

`lpunpack` provides the essential bridge between Android's dynamic partition architecture and practical firmware engineering.

By extracting individual logical partitions from `super.img`, it enables each filesystem to be analyzed, mounted, modified, and validated independently.

This workflow forms the basis of all subsequent ROM customization performed during the HY300 Ultimate project.

---

# Next Chapter

With the logical partitions successfully extracted, the next chapter focuses on modifying the **system image** itself.

Topics include:

- mounting `system.img`;
- replacing APKs;
- editing configuration files;
- preserving filesystem integrity;
- validating modifications before rebuilding the firmware.

---

> [!IMPORTANT]
> Dynamic partitions should always be extracted before they are modified. Treat `super.img` as an immutable container and perform all engineering work on verified copies of the individual logical images. This approach preserves the integrity of the original firmware while providing a safe and reproducible reconstruction workflow.