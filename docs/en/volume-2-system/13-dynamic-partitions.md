---
title: "Dynamic Partitions"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Dynamic Partitions

> *"Dynamic partitions transformed Android storage from a fixed layout into a flexible, metadata-driven architecture."*

---

# Introduction

Beginning with Android 10, Google introduced **Dynamic Partitions** to simplify firmware maintenance and enable more efficient over-the-air (OTA) updates.

Instead of assigning a fixed physical partition to every system component, Android now groups multiple **logical partitions** inside a single physical container named **super.img**.

The HY300 Ultimate firmware follows this architecture.

Understanding how dynamic partitions work is essential before attempting firmware extraction, modification, or reconstruction.

---

# Why Dynamic Partitions?

Traditional Android devices relied on fixed partition sizes.

A typical layout looked like this:

```text
eMMC Storage

├── boot
├── system
├── vendor
├── product
├── userdata
└── cache
```

Each partition occupied a predefined amount of storage.

Increasing the size of one partition often required repartitioning the entire device.

Dynamic partitions eliminate this limitation.

---

# The Dynamic Partition Concept

Instead of allocating storage directly, Android groups several logical partitions inside a shared storage container.

```text
Physical Storage

└── super.img
      │
      ├── system
      ├── vendor
      ├── product
      ├── odm
      └── system_ext
```

Each logical partition consumes only the space it actually needs.

Unused space can later be reallocated during firmware updates.

---

# Benefits

Dynamic partitions provide several advantages.

- Flexible storage allocation.
- Simplified OTA updates.
- Reduced wasted space.
- Easier partition resizing.
- Improved firmware maintainability.
- Better support for seamless updates.

These benefits are particularly valuable for manufacturers maintaining multiple firmware revisions.

---

# super.img

The **super** partition acts as a container rather than a traditional filesystem.

It contains:

- logical partition metadata;
- partition descriptors;
- partition extents;
- logical partition images.

It does **not** directly expose a mountable filesystem.

Instead, Android maps each logical partition through the Device Mapper during boot.

---

# Logical Partitions

Typical logical partitions include:

| Logical Partition | Purpose                                  |
| ----------------- | ---------------------------------------- |
| system            | Android operating system                 |
| vendor            | Vendor drivers and libraries             |
| product           | OEM applications and resources           |
| odm               | Device-specific customization            |
| system_ext        | Extended framework components (optional) |

The exact layout varies between manufacturers.

---

# Device Mapper

During startup, Android creates virtual block devices.

Simplified sequence:

```text
super.img

↓

LP Metadata

↓

Device Mapper

↓

/dev/block/dm-0

↓

Mounted Filesystem
```

Applications never access `super.img` directly.

Instead, they interact with mapped logical partitions.

---

# LP Metadata

Dynamic partitions are described by **Logical Partition (LP) Metadata**.

The metadata records:

- partition names;
- sizes;
- groups;
- block extents;
- attributes;
- slot information.

Without valid metadata, Android cannot reconstruct the logical partition layout.

---

# Inspecting LP Metadata

Display metadata:

```bash
lpdump super.img
```

Display every slot:

```bash
lpdump --slot=all super.img
```

These commands reveal how logical partitions are organized internally.

---

# Extracting Partitions

Logical partitions can be extracted using:

```bash
lpunpack super.img extracted/
```

Example output:

```text
extracted/

├── system.img
├── vendor.img
├── product.img
├── odm.img
└── system_ext.img
```

Each extracted image can then be analyzed independently.

---

# Typical Workflow

```text
super.img

↓

lpunpack

↓

Logical Partitions

↓

Filesystem Analysis

↓

Modification

↓

Validation

↓

Rebuild
```

This workflow became the foundation of the HY300 Ultimate reconstruction process.

---

# Rebuilding super.img

After modifying one or more logical partitions, the container must be rebuilt.

Android provides:

```bash
lpmake
```

The command reconstructs:

- LP metadata;
- partition groups;
- partition extents;
- new super image.

Every partition size must be consistent with the metadata.

---

# Relationship Between Partitions

```text
super.img
      │
      ├────────────┐
      │            │
      ▼            ▼
system        vendor
      │            │
      └──────┬─────┘
             ▼
           Android
```

Although logically separated, these partitions work together during boot.

Replacing one partition without considering its dependencies may introduce compatibility issues.

---

# Sparse Images

Many Android firmware packages store logical partitions using the **Sparse Image** format.

Before mounting them:

```bash
simg2img system.img system.raw.img
```

After modification:

```bash
img2simg system.raw.img system.img
```

This conversion is a standard part of Android firmware analysis.

---

# Filesystem Validation

Before rebuilding `super.img`, each filesystem should be verified.

```bash
e2fsck -f system.raw.img
```

Resize if necessary.

```bash
resize2fs
```

Only validated filesystems should be reintegrated into the firmware.

---

# OTA Updates

Dynamic partitions greatly simplify OTA updates.

Instead of rewriting the entire firmware:

```text
OTA Package

↓

Modified Logical Partition

↓

Metadata Update

↓

Reboot

↓

Validation
```

Only the modified partitions require updating.

This reduces update size and installation time.

---

# Engineering Challenges

Dynamic partitions also introduce additional complexity.

Typical challenges include:

- metadata consistency;
- partition size calculations;
- extent alignment;
- group allocation;
- sparse image handling;
- rebuilding `super.img`.

Understanding these concepts is essential before attempting custom firmware development.

---

# Practical Considerations

During the HY300 Ultimate project:

- original `super.img` files were preserved;
- partitions were extracted individually;
- modifications were performed on working copies;
- ext4 filesystems were validated;
- reconstructed images were verified before testing.

This methodology minimized the risk of corrupting the original firmware.

---

# Best Practices

When working with dynamic partitions:

- Always preserve the original `super.img`.
- Inspect metadata before making changes.
- Validate every extracted filesystem.
- Rebuild only after successful verification.
- Calculate SHA-256 hashes before and after reconstruction.
- Keep detailed records of partition sizes and metadata.

---

# Summary

Dynamic partitions represent one of the most significant architectural changes introduced in modern Android.

By grouping multiple logical partitions inside a flexible storage container, Android improves maintainability, simplifies OTA updates, and allows manufacturers greater flexibility.

For firmware engineers, however, this architecture introduces additional complexity that must be understood before modifications can be performed safely.

The HY300 Ultimate project relies heavily on this knowledge throughout the firmware reconstruction process.

---

# Next Chapter

Now that the dynamic partition architecture has been established, the investigation examines the purpose of each major Android partition individually.

The following chapter focuses on:

- `system`
- `vendor`
- `odm`
- `product`
- `system_ext`

and explains how these partitions cooperate to form the complete Android operating system.

---

> [!IMPORTANT]
> Dynamic partitions separate **storage management** from **filesystem content**. Successful firmware reconstruction therefore requires validating both the integrity of each logical partition and the consistency of the metadata that binds them together.