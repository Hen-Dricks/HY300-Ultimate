---
title: "Boot, Recovery and vbmeta"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Boot, Recovery and vbmeta

> *"A modern Android device does not simply load an operating system. It verifies, initializes, and validates every critical stage before Android ever reaches the home screen."*

---

# Introduction

The previous chapters examined Android's storage architecture and logical partitions.

This chapter focuses on three partitions that play a central role during startup:

- `boot`
- `recovery`
- `vbmeta`

Together, they define how Android starts, how maintenance operations are performed, and how firmware integrity is verified.

Understanding these partitions is essential before modifying firmware images or rebuilding a custom ROM.

---

# Overview

The relationship between these partitions is illustrated below.

```text
Power On

↓

Boot ROM

↓

Bootloader

↓

vbmeta

↓

boot.img

↓

Linux Kernel

↓

init

↓

Android Framework
```

If any critical verification fails, Android may refuse to continue booting depending on the device configuration.

---

# The `boot` Partition

The `boot` partition contains everything required to start the Android operating system.

Unlike the `system` partition, it is relatively small but absolutely critical.

A typical boot image contains:

- Linux kernel
- Ramdisk
- Boot header
- Kernel command line
- Boot configuration

Without a valid `boot.img`, Android cannot start.

---

# Typical Boot Image Layout

```text
boot.img

├── Boot Header
├── Linux Kernel
├── Ramdisk
├── Device Tree (optional)
└── Boot Configuration
```

Although the exact format varies between Android versions, these components are present in most modern boot images.

---

# Linux Kernel

The kernel is the first executable component loaded after the bootloader.

Its responsibilities include:

- memory initialization;
- process scheduling;
- hardware driver initialization;
- interrupt handling;
- virtual memory management;
- filesystem support;
- security primitives.

Once the kernel is operational, it launches Android userspace.

---

# Ramdisk

The ramdisk is a temporary root filesystem loaded into memory during boot.

It contains:

- `init`
- initialization scripts
- early configuration files
- startup resources

The ramdisk exists only during the early stages of boot before Android mounts the permanent system partitions.

---

# Android `init`

The first userspace process is:

```text
init
```

Responsibilities include:

- parsing `.rc` configuration files;
- mounting partitions;
- starting native services;
- loading Android properties;
- launching system daemons.

Every Android process ultimately descends from `init`.

---

# The `recovery` Partition

Many Android devices include a dedicated `recovery` partition.

Recovery provides an isolated maintenance environment independent of the main operating system.

Typical capabilities include:

- installing update packages;
- factory reset;
- clearing user data;
- diagnostics;
- firmware maintenance.

Some embedded devices instead integrate recovery functionality into the boot image.

---

# Recovery Boot Flow

```text
Power On

↓

Bootloader

↓

Recovery Image

↓

Recovery Environment

↓

Maintenance Operations
```

Recovery can usually be entered using:

```bash
adb reboot recovery
```

or a hardware key combination.

---

# Typical Recovery Components

A recovery image generally contains:

```text
recovery.img

├── Linux Kernel
├── Recovery Ramdisk
├── Recovery UI
└── Recovery Utilities
```

The kernel may be identical to the normal boot image or specifically compiled for recovery purposes.

---

# The `vbmeta` Partition

The `vbmeta` partition is part of **Android Verified Boot (AVB)**.

Unlike `boot` or `system`, it contains **verification metadata** rather than executable code.

Its primary purpose is to ensure that critical partitions have not been modified unexpectedly.

---

# Android Verified Boot (AVB)

AVB establishes a chain of trust throughout the boot process.

Simplified sequence:

```text
Bootloader

↓

vbmeta

↓

boot.img

↓

system

↓

vendor

↓

product
```

Each stage verifies the integrity of the next.

---

# What `vbmeta` Contains

Typical metadata includes:

- partition descriptors;
- verification flags;
- rollback information;
- cryptographic hashes;
- digital signatures.

The exact implementation depends on the Android version and device configuration.

---

# Why `vbmeta` Matters

If firmware modifications invalidate the information stored in `vbmeta`, several outcomes are possible:

- boot warning;
- verification failure;
- refusal to boot;
- recovery mode;
- degraded boot state.

Behavior varies depending on manufacturer configuration and security policies.

---

# Relationship Between the Three Partitions

```text
vbmeta
      │
      ▼
boot.img
      │
      ▼
Linux Kernel
      │
      ▼
init
      │
      ▼
Android
```

Recovery operates independently.

```text
Bootloader

├── boot.img

└── recovery.img
```

This separation allows maintenance even when the primary operating system is unavailable.

---

# Inspecting Boot Images

Several tools can be used during analysis.

Example:

```bash
unpack_bootimg.py
```

Display file information.

```bash
file boot.img
```

Calculate integrity hash.

```bash
sha256sum boot.img
```

These operations are entirely non-destructive.

---

# Engineering Considerations

Each partition serves a different purpose.

| Partition | Primary Function        |
| --------- | ----------------------- |
| boot      | Start Android           |
| recovery  | Maintenance environment |
| vbmeta    | Integrity verification  |

Although closely related, they should never be considered interchangeable.

---

# Reverse Engineering Strategy

Within HY300 Ultimate, the investigation followed this workflow.

```text
Preserve Original Images

↓

Calculate SHA-256

↓

Inspect boot.img

↓

Inspect Recovery

↓

Inspect vbmeta

↓

Document Structure

↓

Proceed to Analysis
```

No modifications were performed until the original images had been fully documented.

---

# Common Failure Scenarios

| Failure                | Possible Cause            |
| ---------------------- | ------------------------- |
| Immediate reboot       | Invalid boot image        |
| Endless boot animation | Kernel or init issue      |
| Recovery only          | Boot verification failure |
| Verification warning   | vbmeta mismatch           |
| Boot refusal           | AVB integrity failure     |

Recognizing these symptoms greatly simplifies troubleshooting.

---

# Best Practices

When working with these partitions:

- Always preserve original images.
- Verify hashes before modification.
- Analyze boot images before rebuilding them.
- Document AVB behavior.
- Modify only one component at a time.
- Validate every reconstructed image before flashing.

---

# Summary

The `boot`, `recovery`, and `vbmeta` partitions collectively define how Android starts and protects itself during startup.

The boot image launches the operating system, Recovery provides an independent maintenance environment, and `vbmeta` establishes the integrity verification chain used by Android Verified Boot.

Understanding the responsibilities of each partition is essential before modifying firmware or rebuilding Android images.

---

# Next Chapter

The next chapter examines one of Android's least visible—but most important—components:

the **filesystem table (`fstab`) and mount process**.

Topics include:

- `fstab`
- mount points
- Device Mapper
- filesystem initialization
- mount flags
- Android startup sequence

These mechanisms determine how Android locates and mounts every partition during boot.

---

> [!IMPORTANT]
> Successful firmware modification is not limited to changing files. Every modification must also respect Android's boot architecture and integrity verification mechanisms. Understanding how `boot`, `recovery`, and `vbmeta` interact is therefore a prerequisite for producing stable and recoverable firmware.