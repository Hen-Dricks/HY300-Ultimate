---
title: "OEM Application Inventory"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# OEM Application Inventory

> *"Before removing, replacing, or modifying OEM software, it is essential to understand exactly what is installed and how each component contributes to the operating system."*

---

# Introduction

With Android's architecture now fully documented, the investigation shifts toward the proprietary software delivered with the HY300 firmware.

Unlike standard Android devices based purely on AOSP, commercial embedded devices typically include numerous manufacturer-developed applications responsible for:

- projector-specific functionality;
- firmware updates;
- hardware calibration;
- multimedia enhancements;
- device management;
- user interface customization.

This chapter establishes a complete inventory of these OEM applications before any reverse engineering or firmware modification is attempted.

---

# Objectives

The inventory process pursued several goals.

- Identify every installed OEM application.
- Distinguish AOSP packages from vendor packages.
- Determine each application's role.
- Identify privileged applications.
- Locate installation directories.
- Detect startup dependencies.
- Build a baseline for later analysis.

This inventory serves as the reference for the remainder of the project.

---

# Why an Inventory Matters

Removing an unfamiliar application without understanding its purpose can easily break firmware functionality.

Examples include:

- autofocus failure;
- keystone malfunction;
- launcher crashes;
- OTA update failures;
- hardware initialization issues.

A complete inventory minimizes these risks by documenting every installed component before modification.

---

# Package Categories

Applications generally fall into one of several categories.

| Category                | Examples               |
| ----------------------- | ---------------------- |
| Android System          | Framework applications |
| Google Components       | (if present)           |
| OEM Applications        | Manufacturer software  |
| Hardware Utilities      | Device control         |
| Maintenance Tools       | Diagnostics            |
| Multimedia Applications | Video, audio, casting  |
| Testing Utilities       | Factory applications   |

The focus of this volume is the OEM-specific software.

---

# Collecting the Inventory

The primary inventory was collected through ADB.

List all installed packages.

```bash
adb shell pm list packages
```

List system applications.

```bash
adb shell pm list packages -s
```

List third-party applications.

```bash
adb shell pm list packages -3
```

Display package installation path.

```bash
adb shell pm path <package_name>
```

These commands provide a complete view of the software installed on the device.

---

# Locating APK Files

Installed packages typically reside in one of the following locations.

```text
/system/app/

/system/priv-app/

/product/app/

/product/priv-app/

/vendor/app/

/vendor/priv-app/
```

The installation directory often indicates the importance of the application.

---

# Privileged Applications

Applications located under:

```text
priv-app
```

receive elevated privileges.

They may access:

- privileged Android APIs;
- protected system permissions;
- hardware services;
- OEM interfaces.

Such applications require particularly careful analysis before modification.

---

# Typical OEM Inventory

A simplified inventory might resemble the following.

| Application       | Category           |
| ----------------- | ------------------ |
| OEM Launcher      | User Interface     |
| OTA Updater       | System Maintenance |
| Projector Manager | Hardware Control   |
| Autofocus Service | Hardware Feature   |
| Keystone Service  | Image Processing   |
| Media Player      | Multimedia         |
| QuickShare        | Connectivity       |
| USB Display       | External Display   |

Each package should be documented individually before drawing conclusions about its purpose.

---

# Package Information

Detailed information can be obtained using:

```bash
adb shell dumpsys package <package_name>
```

Useful information includes:

- version;
- permissions;
- shared libraries;
- activities;
- services;
- broadcast receivers;
- installation path.

This metadata often provides valuable clues regarding application functionality.

---

# Identifying Startup Applications

Not every installed application runs automatically.

Startup behavior depends on:

- boot receivers;
- services;
- property triggers;
- init scripts;
- launcher integration.

Applications launched during boot deserve particular attention because they frequently implement core device functionality.

---

# Dependency Mapping

Applications rarely operate in isolation.

Simplified dependency example:

```text
Launcher

↓

Projector Manager

↓

Hardware Service

↓

Vendor Library

↓

HAL

↓

Kernel Driver
```

Understanding these relationships prevents accidental removal of required components.

---

# OEM vs AOSP

One objective of the inventory is distinguishing between standard Android software and manufacturer additions.

```text
Android Framework
        │
        ▼
 Standard AOSP Apps
        │
        ▼
 OEM Applications
        │
        ▼
 Proprietary Hardware Features
```

This distinction guides later reverse engineering efforts.

---

# Reverse Engineering Workflow

The project followed a structured inventory process.

```text
List Packages

↓

Locate APK

↓

Collect Metadata

↓

Classify Applications

↓

Map Dependencies

↓

Document Findings

↓

Select Reverse Engineering Targets
```

Each step reduced uncertainty before deeper analysis.

---

# Documentation Strategy

Every OEM package was documented using a consistent template.

| Field                        | Description                    |
| ---------------------------- | ------------------------------ |
| Package Name                 | Android package identifier     |
| APK Location                 | Installation path              |
| Version                      | Application version            |
| Category                     | Functional classification      |
| Privileged                   | Yes / No                       |
| Startup Behavior             | Automatic / Manual             |
| Dependencies                 | Related services and libraries |
| Reverse Engineering Priority | Low / Medium / High            |

Maintaining a consistent format simplifies future comparison between firmware versions.

---

# Engineering Considerations

Several principles guided the inventory.

- Never remove software during identification.
- Preserve original APKs.
- Record SHA-256 hashes.
- Distinguish observations from assumptions.
- Verify package functionality before modification.

These precautions greatly reduce the risk of destabilizing the firmware.

---

# Common Challenges

Typical challenges include:

- obfuscated package names;
- undocumented OEM software;
- shared libraries between applications;
- hidden startup services;
- vendor-specific permissions;
- proprietary communication mechanisms.

These challenges reinforce the need for systematic documentation.

---

# Best Practices

When building an OEM application inventory:

- Document every package before modifying any of them.
- Preserve original APK files.
- Record installation paths.
- Identify privileged applications first.
- Map dependencies before removal.
- Compare multiple firmware versions whenever available.

---

# Summary

The OEM application inventory provides the first detailed view of the proprietary software installed on the HY300 projector.

Rather than treating the firmware as a collection of unrelated APKs, the investigation establishes a structured catalog that distinguishes Android components from manufacturer customizations.

This inventory becomes the foundation for all subsequent reverse engineering activities.

---

# Next Chapter

The first application selected for detailed analysis is the **TXCZ application**, which plays a central role in the projector's firmware update mechanism.

The next chapter examines:

- application structure;
- OTA functionality;
- update workflow;
- network communication;
- interaction with Android system services.

Understanding this component is essential before modifying the firmware update process.

---

> [!IMPORTANT]
> A complete application inventory is more than a list of installed packages. It is a dependency map of the firmware itself. Every reverse engineering decision made later in this project is grounded in the systematic documentation established in this chapter.