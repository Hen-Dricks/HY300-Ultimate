---
title: "fstab and Mount Process"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# fstab and Mount Process

> *"Android cannot use a partition until it knows where to mount it. The filesystem table is therefore one of the earliest and most critical pieces of system configuration."*

---

# Introduction

After understanding Android's partition layout and boot architecture, the next step is to examine **how Android makes those partitions available to the operating system**.

This process is controlled primarily by:

- `fstab`
- Android `init`
- Device Mapper
- the Linux Virtual Filesystem (VFS)

Together, these components determine:

- which partitions are mounted;
- where they appear;
- how they are mounted;
- which security policies apply.

Without a correct mount process, Android cannot complete its initialization.

---

# What is `fstab`?

`fstab` stands for **Filesystem Table**.

It is a configuration file used during boot to describe:

- block devices;
- mount points;
- filesystem types;
- mount options;
- Android-specific flags.

Unlike desktop Linux distributions, Android's `fstab` is parsed by **init** rather than the traditional Linux `mount` utilities.

---

# Why It Matters

Every Android partition must be mounted before it can be accessed.

Examples include:

- `/system`
- `/vendor`
- `/product`
- `/odm`
- `/data`

If even one critical partition fails to mount correctly, Android may fail to boot.

---

# Boot Relationship

The mount process occurs immediately after kernel initialization.

```text
Bootloader

↓

boot.img

↓

Linux Kernel

↓

init

↓

Read fstab

↓

Mount Partitions

↓

Launch Android Services

↓

Android Framework
```

This makes `fstab` one of the earliest configuration files processed during startup.

---

# Typical fstab Entries

A simplified example:

```text
/dev/block/dm-0   /system   ext4   ro,barrier=1
/dev/block/dm-1   /vendor   ext4   ro
/dev/block/dm-2   /product  ext4   ro
/dev/block/dm-3   /odm      ext4   ro
/dev/block/dm-4   /data     ext4   rw
```

Each line specifies:

- block device;
- mount point;
- filesystem type;
- mount options.

---

# Mount Points

Android exposes partitions through mount points.

Typical layout:

```text
/

├── system
├── vendor
├── product
├── odm
├── data
├── metadata
├── storage
└── mnt
```

Applications interact with these directories rather than with raw partitions.

---

# Device Mapper

On modern Android devices, `fstab` rarely references physical partitions directly.

Instead, it commonly mounts Device Mapper nodes.

Example:

```text
/dev/block/dm-0
```

Device Mapper translates these logical devices into the appropriate extents inside `super.img`.

```text
super.img

↓

LP Metadata

↓

Device Mapper

↓

dm-0

↓

/system
```

---

# Read-Only vs Read-Write

Most system partitions are mounted read-only.

| Partition | Typical Mode |
| --------- | ------------ |
| system    | Read-only    |
| vendor    | Read-only    |
| product   | Read-only    |
| odm       | Read-only    |
| data      | Read-write   |

This protects the operating system against unintended modifications during normal operation.

---

# Android Mount Flags

Common mount options include:

| Option      | Purpose                  |
| ----------- | ------------------------ |
| `ro`        | Read-only                |
| `rw`        | Read-write               |
| `nosuid`    | Ignore SUID bits         |
| `nodev`     | Disable device files     |
| `noexec`    | Prevent executable files |
| `barrier=1` | Filesystem integrity     |
| `discard`   | Enable TRIM support      |

Android also introduces several platform-specific flags interpreted by `init`.

---

# Inspecting Mounted Filesystems

Display mounted partitions.

```bash
adb shell mount
```

Alternative:

```bash
adb shell cat /proc/mounts
```

Display filesystem usage.

```bash
adb shell df -h
```

Display mount tree.

```bash
adb shell findmnt
```

These commands provide valuable insight into the runtime filesystem layout.

---

# Android init and fstab

During startup, Android `init` performs several operations.

```text
Read fstab

↓

Locate Block Devices

↓

Verify Filesystems

↓

Mount Partitions

↓

Apply SELinux Labels

↓

Continue Initialization
```

Failure during any step may interrupt the boot sequence.

---

# Mount Sequence

A simplified initialization order:

```text
metadata

↓

system

↓

vendor

↓

product

↓

odm

↓

data

↓

storage
```

The precise sequence depends on Android version and device configuration.

---

# Relationship with Dynamic Partitions

Because the HY300 firmware uses dynamic partitions:

```text
super.img

↓

Device Mapper

↓

dm-0

↓

system

↓

fstab

↓

Mount
```

`fstab` interacts with logical partitions rather than directly with physical storage.

---

# Filesystem Types

Most Android partitions use ext4.

Typical examples:

| Partition | Filesystem   |
| --------- | ------------ |
| system    | ext4         |
| vendor    | ext4         |
| product   | ext4         |
| odm       | ext4         |
| data      | ext4 or F2FS |

The filesystem type is specified directly in `fstab`.

---

# SELinux Integration

Mounting is closely tied to SELinux.

During initialization:

- partitions are mounted;
- security contexts are applied;
- services receive appropriate permissions.

Incorrect mount configuration may therefore lead to SELinux denials even when the filesystem itself is valid.

---

# Common Problems

Typical mount-related failures include:

| Problem              | Possible Cause        |
| -------------------- | --------------------- |
| Boot loop            | Missing partition     |
| Read-only filesystem | Incorrect mount flags |
| Mount failure        | Corrupted ext4        |
| Missing applications | Wrong mount point     |
| SELinux errors       | Incorrect contexts    |
| Service failures     | Unmounted partition   |

These symptoms frequently appear together during firmware development.

---

# Reverse Engineering Considerations

During the HY300 Ultimate project, the mount process was documented before any modifications were made.

The investigation focused on:

- mount order;
- logical partition mapping;
- filesystem types;
- Device Mapper nodes;
- SELinux interaction;
- Android initialization.

This information proved essential during firmware reconstruction.

---

# Engineering Workflow

```text
Inspect fstab

↓

List Mount Points

↓

Identify Device Mapper Nodes

↓

Verify Filesystems

↓

Document Configuration

↓

Proceed to Firmware Analysis
```

This workflow minimizes the risk of introducing filesystem-related issues.

---

# Best Practices

When studying Android mounts:

- Never assume mount order.
- Record the complete output of `mount`.
- Preserve original `fstab` files.
- Verify filesystem integrity before modification.
- Understand Device Mapper relationships.
- Consider SELinux when changing mount behavior.

---

# Summary

The filesystem table (`fstab`) defines how Android transforms raw storage into a usable operating system.

Together with `init` and Device Mapper, it determines which partitions are mounted, where they appear in the filesystem hierarchy, and under which security constraints they operate.

A solid understanding of this process is essential for reliable firmware reconstruction and troubleshooting.

---

# Next Chapter

With the filesystem now fully understood, the investigation turns to Android's memory management.

The following chapter examines:

- RAM utilization
- Memory allocation
- ZRAM
- Swap
- Low Memory Killer
- Performance implications

These components play a significant role in the overall responsiveness of embedded Android devices such as the HY300 projector.

---

> [!IMPORTANT]
> A valid partition is not enough for Android to function correctly. Every partition must also be mounted at the correct location, with the correct filesystem, mount options, and security context. The mount process is therefore one of the most fundamental—and most easily overlooked—stages of Android initialization.