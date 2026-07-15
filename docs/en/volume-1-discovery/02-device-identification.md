---
title: "Device Identification"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Device Identification

> *"Before attempting to modify a system, it is essential to know exactly what the system is."*

---

# Introduction

Accurate device identification is the foundation of every firmware analysis.

Many Android-based embedded devices appear nearly identical externally while internally relying on different hardware revisions, storage layouts, bootloaders, or firmware versions.

Assuming that two devices are identical because they share the same commercial name is a common source of failed modifications.

The first objective of the HY300 Ultimate project was therefore to establish a complete hardware and software identity for the target device.

---

# Why Identification Matters

Every subsequent operation depends on correctly identifying the platform.

This includes:

- partition extraction;
- firmware reconstruction;
- OTA analysis;
- bootloader behavior;
- driver compatibility;
- security mechanisms.

Even a minor hardware revision can introduce differences that invalidate previous assumptions.

---

# Initial Inspection

The investigation began with a physical examination of the projector.

The following characteristics were recorded:

- commercial model;
- external connectors;
- available buttons;
- power supply;
- packaging information;
- regulatory labels;
- serial numbers;
- firmware version (when available).

These observations establish the initial baseline before any software analysis.

---

# Software Identification

After the first successful system boot, the firmware was examined using standard Android tools.

Primary information collected included:

- Android version;
- build number;
- security patch level;
- kernel version;
- build fingerprint;
- manufacturer properties;
- product identifiers.

Most of this information can be obtained using Android system properties.

Example:

```bash
adb shell getprop
```

Retrieve a specific property.

```bash
adb shell getprop ro.build.fingerprint
```

Display Android version.

```bash
adb shell getprop ro.build.version.release
```

Display SDK version.

```bash
adb shell getprop ro.build.version.sdk
```

---

# Hardware Platform

The projector is based on a **Rockchip System-on-Chip (SoC)**.

Identifying the SoC is essential because it determines:

- boot architecture;
- supported peripherals;
- graphics stack;
- multimedia framework;
- firmware layout;
- vendor libraries.

The platform also dictates which reverse engineering tools and documentation are applicable.

---

# Collecting Device Information

Useful commands include:

Display every Android property.

```bash
adb shell getprop
```

Kernel information.

```bash
adb shell uname -a
```

CPU information.

```bash
adb shell cat /proc/cpuinfo
```

Memory information.

```bash
adb shell cat /proc/meminfo
```

Mounted filesystems.

```bash
adb shell mount
```

Block devices.

```bash
adb shell ls -l /dev/block
```

These commands provide the initial software inventory without modifying the device.

---

# Identifying Storage

Understanding the storage layout is equally important.

The investigation recorded:

- internal flash type;
- logical partitions;
- mount points;
- filesystem types;
- available storage capacity.

Example:

```bash
adb shell df -h
```

List named partitions.

```bash
adb shell ls -l /dev/block/by-name
```

---

# Android Build Information

Several Android properties provide valuable identification data.

Common examples include:

| Property                   | Description                  |
| -------------------------- | ---------------------------- |
| `ro.product.model`         | Device model                 |
| `ro.product.brand`         | Manufacturer brand           |
| `ro.build.fingerprint`     | Complete firmware identifier |
| `ro.build.version.release` | Android version              |
| `ro.build.version.sdk`     | Android SDK level            |
| `ro.build.display.id`      | Firmware build identifier    |

These properties help distinguish different firmware revisions.

---

# Verifying the Environment

Before proceeding further, the following elements were verified.

- ADB connectivity
- Stable boot
- Accessible shell
- Working filesystem
- Readable partitions
- Functional network connection

This validation ensured that subsequent experiments could be performed safely.

---

# Initial Device Profile

The investigation established a preliminary device profile containing:

| Category          | Information                      |
| ----------------- | -------------------------------- |
| Device            | HY300 Projector                  |
| Operating System  | Android                          |
| Hardware Platform | Rockchip SoC                     |
| Storage           | Dynamic Android partitions       |
| Firmware          | OEM build                        |
| Debug Access      | ADB available                    |
| Research Status   | Initial identification completed |

This profile was progressively refined throughout the project as additional information became available.

---

# Challenges

Several challenges emerged during the identification phase.

Examples included:

- inconsistent documentation across online sources;
- different commercial names referring to similar hardware;
- proprietary firmware components;
- undocumented vendor applications;
- uncertainty regarding hardware revisions.

These observations reinforced the importance of relying on direct evidence rather than external assumptions.

---

# Methodology

The identification process followed a simple but rigorous workflow.

```text
Physical Inspection

↓

System Boot

↓

ADB Connection

↓

Collect System Properties

↓

Identify Hardware

↓

Map Storage

↓

Verify Environment

↓

Document Findings
```

Each step produced information that supported the next stage of the investigation.

---

# Best Practices

During device identification:

- Avoid modifying the system.
- Record every observation.
- Preserve original firmware information.
- Save command outputs whenever possible.
- Verify collected data using multiple independent sources.
- Distinguish confirmed facts from working hypotheses.

A careful identification phase significantly reduces errors later in the reverse engineering process.

---

# Summary

At the end of this chapter, the target device had been successfully identified as an Android-based projector built on a Rockchip platform.

The operating system, storage layout, and debugging environment were sufficiently understood to begin a deeper investigation.

No firmware modifications had yet been performed.

The project remained entirely in the observation phase.

---

# Next Chapter

With the hardware and software platform identified, the next step is to establish the initial hypotheses that will guide the remainder of the investigation.

These hypotheses define which components deserve further analysis and provide a structured framework for future experimentation.

---

> [!NOTE]
> Accurate device identification is not a one-time task. As reverse engineering progresses, new evidence may refine or even correct earlier assumptions. Maintaining an up-to-date device profile throughout the project ensures that documentation remains accurate and reproducible.