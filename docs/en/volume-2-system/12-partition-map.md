---
title: "Partition Map"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Partition Map

> *"Understanding where Android stores its components is just as important as understanding how those components work."*

---

# Introduction

Modern Android devices are divided into multiple partitions, each serving a specific purpose within the operating system.

Unlike traditional Linux systems that rely on a small number of filesystem partitions, Android distributes its components across several dedicated images.

The HY300 Ultimate projector follows this architecture and makes extensive use of **dynamic partitions**, allowing multiple logical partitions to coexist within a single physical container.

Before modifying any firmware image, it is essential to understand how these partitions are organized and how they interact.

---

# Why the Partition Map Matters

Every firmware modification ultimately affects one or more partitions.

Understanding the partition layout allows engineers to:

- identify where Android components are stored;
- determine which partitions can be modified safely;
- avoid unnecessary changes;
- diagnose boot failures;
- rebuild firmware correctly;
- preserve compatibility with OTA updates.

Without an accurate partition map, firmware reconstruction becomes largely experimental.

---

# Android Storage Layout

A simplified storage layout is illustrated below.

```text
+------------------------------------------------+
| Bootloader                                     |
+------------------------------------------------+
| boot.img                                       |
+------------------------------------------------+
| recovery.img (optional)                        |
+------------------------------------------------+
| vbmeta.img                                     |
+------------------------------------------------+
| super.img                                      |
|   ├── system                                   |
|   ├── vendor                                   |
|   ├── product                                  |
|   ├── odm                                      |
|   └── system_ext (optional)                    |
+------------------------------------------------+
| userdata                                       |
+------------------------------------------------+
| metadata                                       |
+------------------------------------------------+
| cache (device dependent)                       |
+------------------------------------------------+
```

Although partition names may vary slightly between firmware versions, this structure closely reflects modern Android devices.

---

# Physical vs Logical Partitions

Android distinguishes between **physical partitions** and **logical partitions**.

Physical partitions exist directly on the storage medium.

Examples include:

- boot
- vbmeta
- super
- userdata
- metadata

Logical partitions reside inside `super.img`.

Examples include:

- system
- vendor
- product
- odm
- system_ext

This abstraction allows greater flexibility during firmware updates.

---

# Discovering the Partition Layout

Several Android commands can be used to inspect the partition map.

List named partitions.

```bash
adb shell ls -l /dev/block/by-name
```

Display mounted filesystems.

```bash
adb shell mount
```

List block devices.

```bash
adb shell ls -l /dev/block
```

Display disk usage.

```bash
adb shell df -h
```

These commands provide a reliable overview of the device's storage organization.

---

# Typical Android Partitions

The following table summarizes the primary Android partitions.

| Partition | Purpose                               |
| --------- | ------------------------------------- |
| boot      | Linux kernel and ramdisk              |
| vbmeta    | Android Verified Boot metadata        |
| super     | Container for logical partitions      |
| system    | Android operating system              |
| vendor    | Vendor-specific libraries and drivers |
| product   | OEM applications and resources        |
| odm       | Device-specific customizations        |
| userdata  | User applications and data            |
| metadata  | Encryption and metadata information   |

Not every device implements every partition, but the overall architecture remains similar.

---

# The Role of `super.img`

Unlike earlier Android versions, modern devices consolidate multiple logical partitions inside a single physical partition named `super`.

```text
super.img

├── system
├── vendor
├── product
├── odm
└── system_ext
```

This design simplifies OTA updates and enables more flexible partition management.

The internal organization of `super.img` is examined in detail in the next chapter.

---

# Partition Dependencies

Android partitions are not independent.

Several components rely on one another.

```text
boot.img
      │
      ▼
system
      │
      ▼
vendor
      │
      ▼
HAL
      │
      ▼
Hardware
```

Replacing one partition without considering its dependencies may lead to instability or boot failures.

---

# Inspecting Mount Points

Mounted partitions can be examined using:

```bash
adb shell mount
```

Example output:

```text
/dev/block/dm-0 on /system

/dev/block/dm-1 on /vendor

/dev/block/dm-2 on /product
```

Device-mapper (`dm-*`) devices are commonly used with dynamic partitions.

---

# Filesystem Types

Most Android system partitions use the **ext4** filesystem.

Common examples include:

| Partition | Filesystem   |
| --------- | ------------ |
| system    | ext4         |
| vendor    | ext4         |
| product   | ext4         |
| odm       | ext4         |
| userdata  | ext4 or F2FS |

The exact filesystem depends on the manufacturer and Android version.

---

# Partition Discovery Workflow

The investigation followed a structured process.

```text
ADB Connection

↓

List Block Devices

↓

Identify Named Partitions

↓

Inspect Mount Points

↓

Determine Filesystem Types

↓

Document Layout

↓

Validate Findings
```

Each step contributed to building an accurate partition map.

---

# Engineering Considerations

When analyzing partitions, several principles should be observed.

- Never modify the original firmware image.
- Document partition sizes before making changes.
- Record filesystem types.
- Verify SHA-256 hashes.
- Understand partition dependencies.
- Preserve the original layout whenever possible.

These precautions greatly simplify firmware reconstruction.

---

# Common Challenges

Partition analysis may present several difficulties.

Examples include:

- undocumented OEM partitions;
- dynamic partition metadata;
- compressed sparse images;
- varying partition names;
- vendor-specific layouts.

Careful inspection is therefore essential before making assumptions.

---

# Best Practices

During partition analysis:

- Work from verified firmware images.
- Preserve the original partition map.
- Use read-only operations whenever possible.
- Document every identified partition.
- Compare multiple firmware versions when available.
- Validate every observation with more than one command.

---

# Summary

This chapter introduced the storage organization of the HY300 projector and established the partition map used throughout the remainder of the project.

Understanding how Android distributes its components across physical and logical partitions provides the foundation for firmware extraction, modification, and reconstruction.

The next chapter explores the most important element of this architecture: **dynamic partitions** and the internal structure of `super.img`.

---

# Next Chapter

The following chapter examines Android's dynamic partition system in detail.

Topics include:

- Logical partitions
- LP metadata
- `super.img`
- `lpunpack`
- `lpdump`
- `lpmake`
- Dynamic partition reconstruction

These concepts form the technical basis for every firmware modification performed later in the project.

---

> [!IMPORTANT]
> A partition map is more than a storage diagram—it is the blueprint of the operating system. Understanding how Android organizes its partitions is essential for safe reverse engineering, reliable firmware reconstruction, and long-term maintainability.