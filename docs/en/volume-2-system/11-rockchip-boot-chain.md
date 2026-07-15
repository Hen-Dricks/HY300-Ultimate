---
title: "Rockchip Boot Chain"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Rockchip Boot Chain

> *"The boot process is the backbone of every embedded system. Understanding it reveals where the operating system begins, where vendor customizations are introduced, and where firmware modifications can safely be performed."*

---

# Introduction

After examining the overall Android architecture, the next logical step is to understand **how the operating system starts**.

The HY300 projector is built on a **Rockchip System-on-Chip (SoC)**, meaning that the boot sequence combines:

- Rockchip boot firmware;
- Android boot components;
- Linux initialization;
- proprietary OEM software.

Each stage prepares the next one until Android becomes fully operational.

Understanding this chain is essential before modifying boot images, rebuilding firmware, or analyzing startup services.

---

# Why the Boot Chain Matters

Every firmware modification ultimately affects one or more stages of the boot process.

A failure at any point may prevent Android from starting.

Understanding the boot sequence allows engineers to:

- diagnose boot failures;
- identify proprietary initialization steps;
- understand partition dependencies;
- locate security verification mechanisms;
- safely modify firmware images.

---

# Simplified Boot Sequence

The complete startup process can be summarized as follows.

```text
Power On

↓

Boot ROM

↓

Rockchip Bootloader

↓

Android Bootloader

↓

boot.img

↓

Linux Kernel

↓

init

↓

Android Framework

↓

Launcher

↓

User
```

Each component depends on the successful completion of the previous stage.

---

# Stage 1 — Boot ROM

The Boot ROM is permanently embedded inside the Rockchip SoC.

Its responsibilities include:

- hardware initialization;
- memory controller setup;
- locating boot media;
- loading the first bootloader.

Because Boot ROM resides in read-only silicon, it cannot be modified through firmware updates.

It represents the immutable root of the startup process.

---

# Stage 2 — Rockchip Bootloader

The first software loaded from storage is the Rockchip bootloader.

Typical responsibilities include:

- DRAM initialization;
- storage configuration;
- boot source selection;
- loading secondary boot stages;
- preparing execution of the Android bootloader.

Different Rockchip platforms may implement slightly different bootloader architectures.

---

# Stage 3 — Android Bootloader

The Android bootloader prepares the transition into the operating system.

Typical responsibilities include:

- loading `boot.img`;
- verifying partitions (when enabled);
- preparing kernel parameters;
- exposing Fastboot (when supported);
- selecting boot mode.

At this stage, security mechanisms such as Android Verified Boot (AVB) may already become active.

---

# Stage 4 — boot.img

The boot image generally contains:

- Linux kernel;
- ramdisk;
- boot configuration;
- kernel command line.

Simplified structure:

```text
boot.img

├── Kernel
├── Ramdisk
├── Header
└── Boot Configuration
```

The kernel and ramdisk together provide the environment required for Android initialization.

---

# Stage 5 — Linux Kernel

After `boot.img` is loaded, execution transfers to the Linux kernel.

The kernel performs:

- scheduler initialization;
- memory management;
- driver loading;
- interrupt configuration;
- device discovery;
- filesystem support.

Only after the kernel is fully operational can Android userspace begin.

---

# Stage 6 — init

The first userspace process launched by Android is `init`.

Its responsibilities include:

- parsing init scripts;
- mounting filesystems;
- applying system properties;
- starting native services;
- launching Android services.

Every Android process ultimately descends from `init`.

---

# Stage 7 — Native Services

During initialization, Android starts numerous native daemons.

Examples include:

- vold
- servicemanager
- logd
- adbd
- hwservicemanager

OEM firmware may also introduce proprietary services responsible for hardware-specific features.

These services become a major focus of later reverse engineering.

---

# Stage 8 — Android Framework

Once low-level services have started, the Android Framework becomes operational.

Framework initialization includes:

- Package Manager
- Activity Manager
- Window Manager
- Display Manager
- Power Manager
- SystemUI

At this point Android transitions from system initialization to application execution.

---

# Stage 9 — Launcher

The final visible stage is the Launcher.

Responsibilities include:

- displaying the home screen;
- starting user applications;
- presenting the graphical interface.

In OEM firmware, the launcher is frequently customized to provide a branded user experience.

---

# OEM Initialization

The HY300 firmware introduces additional initialization steps beyond standard Android.

Examples include:

- proprietary background daemons;
- projector hardware initialization;
- keystone services;
- autofocus services;
- vendor configuration;
- OEM launcher startup.

One objective of later chapters is identifying exactly where these components integrate into the startup sequence.

---

# Boot Flow Diagram

```text
Power On
     │
     ▼
Boot ROM
     │
     ▼
Rockchip Bootloader
     │
     ▼
Android Bootloader
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
Native Services
     │
     ▼
Android Framework
     │
     ▼
OEM Services
     │
     ▼
Launcher
     │
     ▼
User Applications
```

This diagram illustrates both the standard Android startup sequence and the points where vendor-specific software is introduced.

---

# Security During Boot

Several security mechanisms may be involved throughout startup.

Examples include:

- bootloader verification;
- Android Verified Boot (AVB);
- `vbmeta`;
- SELinux initialization;
- verified partitions;
- filesystem integrity checks.

The exact implementation depends on the firmware configuration.

These mechanisms are discussed in greater detail in later chapters.

---

# Engineering Considerations

When modifying firmware, understanding the boot chain is critical.

Typical examples include:

| Modification         | Affected Stage        |
| -------------------- | --------------------- |
| Kernel patch         | boot.img              |
| Ramdisk modification | init                  |
| Service removal      | Native services       |
| Launcher replacement | Android Framework     |
| Library replacement  | Vendor initialization |
| Partition rebuild    | Bootloader validation |

Mapping modifications to the correct boot stage simplifies troubleshooting considerably.

---

# Common Failure Points

Boot failures typically occur during one of the following stages.

| Stage      | Typical Symptoms            |
| ---------- | --------------------------- |
| Bootloader | No boot or black screen     |
| boot.img   | Immediate reboot            |
| Kernel     | Kernel panic                |
| init       | Boot loop                   |
| Framework  | Endless boot animation      |
| Launcher   | Blank or unusable interface |

Recognizing these symptoms significantly accelerates debugging.

---

# Best Practices

When investigating the boot chain:

- Preserve original boot images.
- Document every boot stage.
- Modify only one component at a time.
- Verify hashes before rebuilding.
- Collect `logcat` and `dmesg` whenever possible.
- Distinguish Android behavior from OEM customizations.

---

# Summary

The Rockchip boot chain combines standard Android initialization with manufacturer-specific software responsible for projector functionality.

Understanding each stage allows engineers to identify where proprietary components integrate into the system and provides the context required for safe firmware modification.

The boot sequence also establishes the relationships between the bootloader, kernel, Android runtime, and user-facing applications.

---

# Next Chapter

Now that the complete startup sequence has been established, the investigation turns to one of the most important structural elements of modern Android firmware:

the **partition map**.

Understanding how storage is organized provides the foundation for firmware extraction, analysis, and reconstruction.

---

> [!IMPORTANT]
> A firmware modification should never be viewed in isolation. Every change affects a specific stage of the boot chain, and understanding those dependencies is essential for maintaining a stable and recoverable Android system.