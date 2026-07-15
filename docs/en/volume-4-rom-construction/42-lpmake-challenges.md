---
title: "Challenges of Rebuilding Dynamic Partitions with lpmake"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-15"
---

# Challenges of Rebuilding Dynamic Partitions with lpmake

> *"Extracting a dynamic partition is relatively straightforward. Rebuilding it correctly requires understanding Android's Logical Partition Metadata, partition groups, alignment rules, and filesystem constraints."*

---

# Introduction

Once modifications have been applied to the extracted filesystem images, the next engineering challenge is reconstructing a valid **super.img**.

Unlike legacy Android devices, modern firmware cannot simply concatenate modified partitions together.

Instead, Android relies on **Logical Partition Metadata (LP Metadata)**, partition groups, alignment rules, and carefully calculated allocation tables.

The primary tool responsible for rebuilding this structure is:

```text
lpmake
```

Throughout the HY300 Ultimate project, rebuilding `super.img` proved to be one of the most technically demanding stages of the firmware reconstruction process.

---

# Objectives

This chapter aims to:

- explain the role of `lpmake`;
- describe Logical Partition Metadata reconstruction;
- document common engineering challenges;
- discuss partition sizing;
- explain alignment considerations;
- establish validation procedures before rebuilding.

The chapter focuses on architecture and methodology rather than specific command-line recipes.

---

# Why lpmake Exists

After Android introduced Dynamic Partitions, firmware engineers required a way to rebuild the logical partition container.

Rather than copying files into a raw image, Android expects a structured container including:

- metadata;
- partition descriptors;
- allocation tables;
- partition groups;
- alignment information.

`lpmake` generates this structure.

---

# Rebuild Workflow

The reconstruction process follows a layered approach.

```text
Modified Filesystems

↓

Logical Partition Images

↓

Partition Metadata

↓

lpmake

↓

super.img

↓

Validation
```

Every layer must remain internally consistent.

---

# Relationship with lpunpack

The two tools complement one another.

```text
super.img

↓

lpunpack

↓

system.img

vendor.img

product.img

↓

Modify

↓

lpmake

↓

New super.img
```

Extraction and reconstruction therefore form opposite phases of the same workflow.

---

# Logical Partition Metadata

LP Metadata describes:

- logical partition names;
- partition sizes;
- physical extents;
- block allocation;
- partition groups;
- metadata version.

The metadata determines how Android reconstructs the logical partitions during boot.

Without valid metadata, an otherwise correct filesystem image cannot be mounted correctly.

---

# Simplified Architecture

```text
super.img

├── Metadata
│
├── system
│
├── vendor
│
├── product
│
└── odm
```

Each logical partition occupies a defined region inside the container.

---

# Partition Groups

Dynamic partitions are organized into groups.

Example:

```text
Main Group

├── system
├── vendor
├── product
└── odm
```

Group definitions determine how available storage is shared among related partitions.

---

# Partition Size Planning

One of the most common engineering challenges involves filesystem growth.

For example:

```text
Original system.img

↓

APK Replacement

↓

Larger Filesystem

↓

Insufficient Space

↓

Rebuild Failure
```

Filesystem expansion therefore affects the entire partition layout.

---

# Alignment Requirements

Logical partitions must satisfy alignment constraints.

Simplified representation:

```text
Block Boundary

↓

Aligned Partition

↓

Next Partition
```

Proper alignment improves compatibility and ensures predictable allocation.

---

# Metadata Consistency

Every logical partition described by LP Metadata must correspond to an actual filesystem image.

Inconsistencies may include:

- incorrect partition size;
- missing partition;
- overlapping extents;
- invalid allocation;
- unsupported metadata version.

These inconsistencies generally prevent successful firmware reconstruction.

---

# Validation Before Rebuilding

Before invoking `lpmake`, every filesystem should be verified.

Recommended checks include:

- ext4 integrity;
- image size;
- SHA-256 checksum;
- expected directory structure;
- configuration consistency.

Validation reduces the likelihood of rebuilding an unusable container.

---

# Integrity Workflow

```text
Modified Filesystem

↓

Filesystem Check

↓

Size Verification

↓

Hash Calculation

↓

Metadata Verification

↓

lpmake

↓

super.img
```

Each stage builds upon the previous one.

---

# Engineering Considerations

Several practical factors influence reconstruction.

Examples include:

- available storage;
- filesystem expansion;
- reserved metadata space;
- alignment boundaries;
- logical partition ordering;
- firmware compatibility.

Small changes to one partition may require recalculating the overall layout.

---

# Common Challenges

Typical issues encountered during reconstruction include:

| Challenge                          | Possible Impact          |
| ---------------------------------- | ------------------------ |
| Filesystem exceeds allocated space | Rebuild failure          |
| Incorrect metadata                 | Invalid `super.img`      |
| Alignment mismatch                 | Boot incompatibility     |
| Missing logical partition          | Incomplete firmware      |
| Incorrect partition group          | Allocation errors        |
| Size miscalculation                | Image generation failure |

Systematic validation greatly reduces these risks.

---

# Reverse Engineering Workflow

The HY300 Ultimate project followed the methodology below.

```text
Verify Filesystems

↓

Measure Partition Sizes

↓

Review LP Metadata

↓

Prepare Partition Layout

↓

Generate super.img

↓

Validate Output

↓

Archive Build
```

This workflow was repeated for every firmware revision.

---

# Engineering Observations

Several lessons emerged throughout the project.

- Metadata is as important as the filesystem itself.
- Small filesystem changes can affect the entire container.
- Consistent partition sizing simplifies rebuilding.
- Validation before reconstruction saves significant debugging time.
- Reproducible workflows reduce engineering errors.

---

# Best Practices

When rebuilding dynamic partitions:

- Preserve the original `super.img`.
- Validate every logical partition before reconstruction.
- Record partition sizes for every build.
- Keep metadata revisions documented.
- Generate SHA-256 hashes for every rebuilt image.
- Archive successful builds before further experimentation.

---

# Summary

Rebuilding Android's dynamic partition container is considerably more complex than modifying individual filesystem images.

`lpmake` combines multiple logical partitions with carefully structured metadata into a valid `super.img`, making partition sizing, alignment, and consistency critical to the reconstruction process.

By validating each filesystem, documenting metadata, and following a disciplined engineering workflow, the HY300 Ultimate project ensured that every reconstructed image remained reproducible and internally consistent.

---

# Next Chapter

With the challenges of `lpmake` understood, the next chapter examines the complete process of **rebuilding `super.img`**.

Topics include:

- assembling logical partitions;
- generating LP metadata;
- validating the rebuilt image;
- comparing it with the original firmware;
- preparing it for firmware testing and release.

---

> [!IMPORTANT]
> In Android's Dynamic Partition architecture, rebuilding `super.img` is fundamentally a metadata engineering task as much as a filesystem task. A valid filesystem alone is insufficient—every logical partition must also be accurately described, aligned, and integrated into a consistent metadata structure before the firmware can be considered complete.