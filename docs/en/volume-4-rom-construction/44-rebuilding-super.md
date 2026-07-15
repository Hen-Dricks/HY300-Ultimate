---
title: "Rebuilding super.img"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-15"
---

# Rebuilding super.img

> *"The final objective of ROM reconstruction is not simply to modify individual partitions, but to assemble them into a coherent firmware image that faithfully represents the intended system architecture."*

---

# Introduction

Previous chapters described how the original firmware was backed up, extracted, analyzed, modified, and prepared for reconstruction.

At this stage of the project, all modified logical partitions have been individually validated.

The remaining task is to rebuild the Android Dynamic Partition container:

```text
super.img
```

Unlike legacy Android firmware, rebuilding `super.img` requires more than packaging filesystem images together.

The reconstruction process combines:

- validated logical partitions;
- Logical Partition Metadata;
- partition groups;
- alignment information;
- allocation tables;
- filesystem consistency.

The resulting image represents the complete operating system that will later be tested and validated.

---

# Objectives

This chapter aims to:

- explain the reconstruction of `super.img`;
- describe how logical partitions are assembled;
- document integrity verification;
- explain engineering validation;
- establish reproducible build procedures;
- prepare the firmware for testing.

The focus is on engineering methodology rather than command-line implementation.

---

# Reconstruction Pipeline

The overall reconstruction process follows a layered workflow.

```text
Modified Partitions

↓

Filesystem Validation

↓

Metadata Preparation

↓

Logical Partition Assembly

↓

super.img

↓

Integrity Validation

↓

Release Candidate
```

Every stage depends on the successful completion of the previous one.

---

# Input Components

The reconstruction process begins with verified filesystem images.

Typical inputs include:

```text
system.img

vendor.img

product.img

odm.img
```

Depending on the firmware version, additional logical partitions may also be included.

Each image should already have:

- verified ext4 integrity;
- documented SHA-256 checksum;
- known filesystem size;
- archived backup.

---

# Reconstruction Architecture

```text
system.img

vendor.img

product.img

odm.img

↓

LP Metadata

↓

Partition Groups

↓

super.img
```

The metadata defines how Android reconstructs the logical partitions during boot.

---

# Preparing the Build

Before rebuilding, every logical partition should be reviewed.

Recommended checks include:

- filesystem integrity;
- partition size;
- available free space;
- alignment requirements;
- metadata consistency;
- dependency validation.

A problem discovered at this stage is generally easier to correct than after the image has been rebuilt.

---

# Metadata Verification

The Logical Partition Metadata must accurately describe every partition.

Examples of information include:

- partition names;
- partition sizes;
- allocation groups;
- physical extents;
- metadata version.

Consistency between metadata and filesystem images is essential.

---

# Image Assembly

The reconstruction stage combines every validated component into a single firmware image.

```text
Verified Filesystems

↓

Partition Layout

↓

Metadata

↓

Image Assembly

↓

super.img
```

No filesystem should be modified during this phase.

Only assembly occurs.

---

# Integrity Verification

After reconstruction, the generated image should be verified.

Recommended validation includes:

Filesystem validation:

```text
✓ Individual images verified
```

Metadata validation:

```text
✓ Logical partition layout verified
```

Image validation:

```text
✓ super.img successfully generated
```

Hash generation:

```bash
sha256sum super.img
```

Every release candidate should receive its own checksum.

---

# Comparing with the Original Firmware

Reconstruction should be compared against the reference firmware.

Comparison criteria include:

| Item                 | Verification               |
| -------------------- | -------------------------- |
| Logical partitions   | Present                    |
| Metadata             | Consistent                 |
| Partition ordering   | Verified                   |
| Image size           | Expected                   |
| Filesystem integrity | Verified                   |
| Boot compatibility   | Pending runtime validation |

The objective is to verify engineering consistency rather than binary identity.

---

# Engineering Workflow

The HY300 Ultimate project adopted the following workflow.

```text
Validate Filesystems

↓

Review Metadata

↓

Assemble Partitions

↓

Generate super.img

↓

Verify Integrity

↓

Generate SHA-256

↓

Archive Build
```

Every firmware revision followed this sequence.

---

# Build Organization

Recommended directory structure:

```text
build/

├── input/
│   ├── system.img
│   ├── vendor.img
│   ├── product.img
│   └── odm.img
│
├── metadata/
│
├── output/
│   └── super.img
│
└── hashes/
```

Separating inputs from generated artifacts improves reproducibility.

---

# Validation Checklist

After rebuilding, several validation points should be reviewed.

- All logical partitions included.
- Metadata generated successfully.
- Image size matches expectations.
- Filesystem integrity previously verified.
- SHA-256 checksum generated.
- Original firmware preserved.
- Build documented.

Only validated images should proceed to testing.

---

# Version Management

Every reconstructed image should receive a unique revision identifier.

Example:

```text
super-v01.img

super-v02.img

super-v03.img
```

Corresponding checksums and engineering notes should be archived alongside each revision.

---

# Documentation

Each build should include:

| Item              | Description |
| ----------------- | ----------- |
| Build Identifier  | Recorded    |
| Firmware Version  | Recorded    |
| Partition Layout  | Verified    |
| SHA-256           | Recorded    |
| Build Date        | Recorded    |
| Engineering Notes | Attached    |

Complete documentation ensures long-term reproducibility.

---

# Engineering Observations

Several lessons emerged throughout reconstruction.

- Metadata consistency is as important as filesystem integrity.
- Small filesystem changes can influence the entire container.
- Reproducible build procedures simplify debugging.
- Image verification should never be skipped.
- Detailed documentation greatly accelerates future revisions.

---

# Common Challenges

Typical reconstruction issues include:

| Challenge                    | Possible Consequence         |
| ---------------------------- | ---------------------------- |
| Incorrect partition metadata | Invalid image                |
| Filesystem growth            | Allocation problems          |
| Partition size mismatch      | Reconstruction failure       |
| Missing logical partition    | Incomplete firmware          |
| Poor version management      | Difficult debugging          |
| Missing validation           | Unreliable release candidate |

Systematic verification minimizes these risks.

---

# Best Practices

When rebuilding `super.img`:

- Validate every logical partition beforehand.
- Preserve immutable backups.
- Generate SHA-256 hashes for every build.
- Archive each firmware revision.
- Maintain detailed engineering notes.
- Treat reconstruction as a repeatable process rather than a one-time operation.

---

# Summary

Rebuilding `super.img` represents the culmination of the firmware reconstruction workflow.

By assembling validated logical partitions within a consistent Dynamic Partition container, the HY300 Ultimate project transformed individual filesystem modifications into a coherent firmware image ready for system-level validation.

Careful metadata management, integrity verification, and disciplined documentation ensured that every build remained reproducible, traceable, and suitable for long-term maintenance.

---

# Next Chapter

With the firmware successfully reconstructed, the next chapter focuses on **bit-for-bit validation**.

Topics include:

- SHA-256 verification;
- binary comparison;
- filesystem consistency;
- reproducibility checks;
- engineering acceptance criteria;
- preparation for release.

This validation phase confirms that the reconstructed firmware meets the project's engineering standards before public distribution.

---

> [!IMPORTANT]
> Rebuilding `super.img` is not the end of the engineering process—it is the beginning of firmware validation. A reconstructed image should be considered a **release candidate**, requiring systematic verification before it can be regarded as a reliable and reproducible firmware build.