---
title: "System, Vendor, ODM and Product Partitions"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# System, Vendor, ODM and Product Partitions

> *"Modern Android separates responsibilities across multiple partitions. Understanding their individual roles is essential before modifying any firmware component."*

---

# Introduction

Previous chapters introduced Android's partition layout and the concept of dynamic partitions.

This chapter examines the four principal logical partitions encountered throughout the HY300 Ultimate firmware:

- `system`
- `vendor`
- `product`
- `odm`

Although they operate together as a single operating system, each partition has a distinct purpose, ownership model, and update lifecycle.

Understanding these boundaries is fundamental to safe firmware customization.

---

# Why Android Separates Partitions

Earlier Android versions stored almost everything inside the `system` partition.

As Android evolved, Google introduced partition separation to improve:

- modularity;
- maintainability;
- hardware portability;
- OTA reliability;
- vendor independence.

Instead of one large operating system image, Android became a collection of specialized components.

---

# Overall Architecture

The relationship between the major partitions can be represented as follows.

```text
                 Android Firmware

                        │
      ┌─────────────────┼─────────────────┐
      │                 │                 │
      ▼                 ▼                 ▼
   system           vendor           product
      │                 │                 │
      └──────────┬──────┴──────────┬──────┘
                 ▼                 ▼
              Android          OEM Features
                 │
                 ▼
               odm
                 │
                 ▼
            Device Hardware
```

Each partition contributes a different layer of functionality.

---

# The `system` Partition

The `system` partition contains the core Android operating system.

Typical contents include:

- Android Framework
- System applications
- Java libraries
- Native libraries
- Core binaries
- Configuration files

Example structure:

```text
system/

├── app/
├── bin/
├── etc/
├── framework/
├── lib/
├── lib64/
├── media/
├── priv-app/
└── usr/
```

Without the `system` partition, Android cannot boot into a functional operating environment.

---

# Responsibilities of `system`

Major responsibilities include:

- application framework;
- package management;
- activity management;
- window management;
- system UI;
- permissions;
- resource management.

Most AOSP components reside here.

---

# The `vendor` Partition

The `vendor` partition contains software supplied by the hardware vendor.

Typical contents include:

- hardware drivers;
- proprietary native libraries;
- HAL implementations;
- firmware blobs;
- hardware configuration files.

Example layout:

```text
vendor/

├── bin/
├── etc/
├── firmware/
├── lib/
├── lib64/
└── overlay/
```

Unlike `system`, this partition is highly hardware-specific.

---

# Responsibilities of `vendor`

Typical components include:

- graphics drivers;
- audio drivers;
- Wi-Fi stack;
- Bluetooth stack;
- display services;
- media codecs;
- camera support;
- projector hardware interfaces.

The HY300 firmware relies extensively on vendor libraries for projector functionality.

---

# The `product` Partition

The `product` partition contains software added by the device manufacturer.

Typical contents include:

- OEM applications;
- custom launcher;
- wallpapers;
- themes;
- localization resources;
- optional system components.

Unlike `vendor`, the software stored here generally operates at the application level.

Example:

```text
product/

├── app/
├── media/
├── overlay/
├── priv-app/
└── etc/
```

---

# Responsibilities of `product`

The manufacturer commonly stores:

- branded applications;
- custom launcher;
- configuration resources;
- user experience enhancements;
- optional services.

During the HY300 investigation, many OEM applications were found in this partition.

---

# The `odm` Partition

ODM stands for **Original Design Manufacturer**.

This partition contains device-specific customizations that may differ between products built from the same hardware platform.

Typical contents include:

- hardware configuration;
- calibration data;
- board-specific binaries;
- OEM customization files;
- specialized libraries.

Not every Android device makes extensive use of the `odm` partition, but many embedded products do.

---

# Responsibilities of `odm`

Typical responsibilities include:

- board configuration;
- display tuning;
- hardware initialization;
- calibration parameters;
- peripheral configuration.

These files often vary between hardware revisions.

---

# Optional Partitions

Some Android devices include additional logical partitions.

Examples:

| Partition          | Purpose                                     |
| ------------------ | ------------------------------------------- |
| `system_ext`       | Additional framework components             |
| `vendor_dlkm`      | Vendor kernel modules                       |
| `odm_dlkm`         | ODM kernel modules                          |
| `product_services` | Device-specific services (vendor dependent) |

The exact layout depends on Android version and manufacturer.

---

# Interaction Between Partitions

Although physically separated, the partitions work together.

```text
system
    │
    ▼
Framework APIs
    │
    ▼
vendor HAL
    │
    ▼
Linux Drivers
    │
    ▼
Hardware
```

Meanwhile:

```text
product

↓

OEM Applications

↓

Android Framework

↓

User
```

The operating system depends on all of these layers functioning correctly.

---

# Modification Strategy

Different partitions require different levels of caution.

| Partition | Modification Risk |
| --------- | ----------------: |
| system    |              High |
| vendor    |         Very High |
| odm       |         Very High |
| product   |          Moderate |

Generally speaking:

- `system` modifications affect Android itself;
- `vendor` modifications affect hardware compatibility;
- `odm` modifications affect board-specific behavior;
- `product` modifications affect OEM features.

---

# Reverse Engineering Priorities

Within the HY300 Ultimate project, the investigation followed this order.

```text
system

↓

product

↓

vendor

↓

odm
```

The reasoning was straightforward.

Understanding standard Android first makes proprietary OEM modifications significantly easier to identify.

---

# Typical Examples

| Component              | Likely Partition |
| ---------------------- | ---------------- |
| Android Framework      | system           |
| Package Manager        | system           |
| OEM Launcher           | product          |
| Projector Application  | product          |
| Wi-Fi Driver           | vendor           |
| Graphics Driver        | vendor           |
| Keystone Configuration | odm              |
| Hardware Calibration   | odm              |

This mapping proved useful during later firmware analysis.

---

# Common Mistakes

Several common mistakes should be avoided.

- Removing vendor libraries without understanding dependencies.
- Moving files between partitions.
- Mixing firmware components from different Android versions.
- Ignoring SELinux contexts.
- Forgetting partition size limitations.
- Modifying multiple partitions simultaneously.

Each of these can introduce difficult-to-diagnose boot failures.

---

# Best Practices

When analyzing Android partitions:

- Preserve the original firmware.
- Study one partition at a time.
- Document every modification.
- Compare OEM files against AOSP equivalents.
- Verify filesystem integrity after changes.
- Rebuild only after successful validation.

---

# Summary

Modern Android distributes responsibilities across multiple specialized partitions.

The `system` partition provides the operating system, `vendor` connects Android to the hardware, `product` delivers manufacturer-specific software, and `odm` contains board-specific customizations.

Understanding these responsibilities allows firmware engineers to distinguish standard Android behavior from proprietary OEM modifications—a key objective of the HY300 Ultimate project.

---

# Next Chapter

The following chapter examines three partitions that play a critical role during startup:

- `boot`
- `recovery`
- `vbmeta`

Together, these partitions determine how Android starts, how firmware updates are validated, and how the integrity of the operating system is protected.

---

> [!IMPORTANT]
> One of the most common causes of firmware instability is misunderstanding partition responsibilities. Before modifying any file, engineers should first determine **which partition owns it**, **why it exists**, and **which other components depend on it**. This discipline greatly reduces the risk of introducing unintended side effects.