---
title: "Appendix B — Partition Commands"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "en"
last_updated: "2026-07-14"
---

# Appendix B — Partition Commands

> *"Understanding Android partitions is the foundation of firmware reverse engineering."*

---

# Purpose

This appendix gathers the primary commands used throughout the HY300 Ultimate project to inspect, extract, verify, modify, and rebuild Android partitions.

Rather than providing an exhaustive Linux storage reference, this document focuses on the commands that are genuinely useful when analyzing Android firmware based on dynamic partitions.

---

# Identifying Partitions

List block devices.

```bash
lsblk
```

Display partition UUIDs.

```bash
blkid
```

Show kernel partition table.

```bash
cat /proc/partitions
```

List Android block devices.

```bash
ls -l /dev/block
```

Display symbolic partition names.

```bash
ls -l /dev/block/by-name
```

---

# Filesystem Information

Display mounted filesystems.

```bash
mount
```

Display mount table.

```bash
cat /proc/mounts
```

Disk usage.

```bash
df -h
```

Detailed mount information.

```bash
findmnt
```

---

# Inspecting Image Files

Identify file type.

```bash
file system.img
```

Display metadata.

```bash
stat system.img
```

Calculate SHA-256.

```bash
sha256sum system.img
```

---

# Sparse ↔ Raw Conversion

Convert Sparse image to Raw.

```bash
simg2img system.img system.raw.img
```

Convert Raw image back to Sparse.

```bash
img2simg system.raw.img system.img
```

These conversions are required before mounting or modifying many Android images.

---

# Mounting ext4 Images

Create a mount point.

```bash
mkdir mount_system
```

Mount the image.

```bash
sudo mount -o loop system.raw.img mount_system
```

Unmount.

```bash
sudo umount mount_system
```

Whenever possible, mount images read-only during inspection.

---

# Verifying ext4 Filesystems

Filesystem check.

```bash
e2fsck -f system.raw.img
```

Automatic repair.

```bash
e2fsck -fy system.raw.img
```

Display filesystem metadata.

```bash
dumpe2fs system.raw.img
```

Display superblock information.

```bash
tune2fs -l system.raw.img
```

---

# Resizing Filesystems

Estimate minimum size.

```bash
resize2fs -P system.raw.img
```

Shrink filesystem.

```bash
resize2fs system.raw.img 3500M
```

Expand filesystem.

```bash
resize2fs system.raw.img
```

Always run `e2fsck` before resizing an ext4 filesystem.

---

# Dynamic Partitions

Extract logical partitions.

```bash
lpunpack super.img extracted/
```

Inspect partition metadata.

```bash
lpdump super.img
```

Rebuild a dynamic partition image.

```bash
lpmake ...
```

The exact `lpmake` parameters depend on the firmware layout.

---

# Inspecting LP Metadata

Display metadata.

```bash
lpdump super.img
```

Inspect all slots.

```bash
lpdump --slot=all super.img
```

---

# Boot Images

Unpack a boot image.

```bash
unpack_bootimg.py
```

Rebuild a boot image.

```bash
mkbootimg
```

These tools are commonly used when analyzing Android boot partitions.

---

# Binary Comparison

Compare two files.

```bash
cmp file1 file2
```

Compare two directories.

```bash
diff -ruN directory1 directory2
```

Hexadecimal inspection.

```bash
xxd system.img
```

---

# Cryptographic Hashes

SHA-256.

```bash
sha256sum file.img
```

SHA-1.

```bash
sha1sum file.img
```

MD5.

```bash
md5sum file.img
```

HY300 Ultimate uses SHA-256 as the primary integrity verification method.

---

# Bit-for-Bit Backup

Create a raw partition dump.

```bash
dd if=/dev/block/... of=partition.img
```

Display progress.

```bash
dd if=... of=... status=progress
```

Flush pending writes.

```bash
sync
```

---

# Compression

Create a compressed archive.

```bash
tar czf backup.tar.gz backups/
```

Extract an archive.

```bash
tar xzf backup.tar.gz
```

Compress with Zstandard.

```bash
zstd
```

Decompress.

```bash
unzstd
```

---

# Android Partition Access

List named partitions.

```bash
adb shell ls -l /dev/block/by-name
```

Dump a partition.

```bash
adb shell dd if=/dev/block/by-name/system of=/sdcard/system.img
```

Retrieve the image.

```bash
adb pull /sdcard/system.img
```

---

# Recommended Validation Sequence

Before rebuilding any partition, follow this workflow.

```text
e2fsck

↓

resize2fs

↓

sha256sum

↓

lpmake
```

This sequence significantly reduces the likelihood of producing an invalid image.

---

# Tools Reference

| Tool      | Purpose                    |
| --------- | -------------------------- |
| lsblk     | List block devices         |
| blkid     | Display filesystem UUIDs   |
| mount     | Mount filesystems          |
| file      | Identify file types        |
| simg2img  | Sparse → Raw conversion    |
| img2simg  | Raw → Sparse conversion    |
| e2fsck    | Verify ext4 filesystems    |
| resize2fs | Resize ext4 filesystems    |
| tune2fs   | Display ext4 metadata      |
| dumpe2fs  | Inspect ext4 superblocks   |
| lpunpack  | Extract dynamic partitions |
| lpdump    | Display LP metadata        |
| lpmake    | Rebuild dynamic partitions |
| dd        | Bit-for-bit copy           |
| sha256sum | Integrity verification     |

---

# Recommended Workflow

```text
OEM Firmware

↓

SHA-256

↓

Backup

↓

Extract

↓

Convert

↓

Mount

↓

Analyze

↓

Modify

↓

e2fsck

↓

resize2fs

↓

SHA-256

↓

lpmake

↓

Validation

↓

Flash
```

---

# Best Practices

- Never modify the original firmware image.
- Calculate SHA-256 hashes before and after every significant operation.
- Mount images read-only whenever possible.
- Always run `e2fsck` before rebuilding an ext4 filesystem.
- Record partition sizes before making modifications.
- Validate each logical partition individually before rebuilding `super.img`.
- Archive logs and executed commands to ensure reproducibility.

---

# Commands Used in HY300 Ultimate

This section is reserved for the exact commands executed during the project.

It will progressively include:

- partition extraction commands;
- validated `lpmake` parameters;
- ext4 verification procedures;
- reconstruction scripts;
- integrity verification commands;
- build validation logs.

Separating the project's real commands from the generic reference makes the documentation easier to reproduce and audit.

---

> [!IMPORTANT]
> Partition modification should always be treated as a reversible process. Every operation must begin with a verified backup and end with integrity validation. A disciplined workflow is the most effective way to prevent data loss, corrupted images, and difficult-to-diagnose boot failures.