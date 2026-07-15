---
title: "Factory and Test Applications"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Factory and Test Applications

> *"Applications intended for manufacturing are often invisible to end users, yet they provide valuable insight into how a device was designed, tested, and calibrated."*

---

# Introduction

Following the analysis of the OTA update application, the investigation turned to another category of OEM software: **factory and testing applications**.

These applications are rarely intended for everyday users.

Instead, they are typically installed during manufacturing to:

- validate hardware;
- calibrate components;
- perform quality assurance;
- diagnose failures;
- verify production consistency.

Although many remain hidden after shipment, they often reveal important information about the hardware platform and proprietary firmware architecture.

---

# Objectives

This investigation pursued several objectives.

- Identify factory applications.
- Determine their purpose.
- Analyze startup behavior.
- Identify privileged permissions.
- Evaluate hardware access.
- Assess whether they are required during normal operation.
- Document their relationship with other OEM components.

No applications were removed during this stage.

---

# Typical Factory Applications

Embedded Android devices commonly include applications such as:

| Category             | Purpose                         |
| -------------------- | ------------------------------- |
| Factory Test         | Production validation           |
| Hardware Diagnostics | Component verification          |
| Aging Test           | Long-duration stability testing |
| Burn-In Test         | Thermal validation              |
| Sensor Test          | Hardware calibration            |
| Display Test         | Image quality verification      |
| Audio Test           | Speaker and microphone testing  |
| Network Test         | Wi-Fi and Bluetooth validation  |

The HY300 firmware includes several utilities that fall into one or more of these categories.

---

# Locating Test Applications

Installed packages can be enumerated using:

```bash
adb shell pm list packages
```

Package location:

```bash
adb shell pm path <package_name>
```

Installation directories often include:

```text
/system/app/

/system/priv-app/

/product/app/

/product/priv-app/
```

Applications located in privileged directories require closer examination.

---

# Manifest Analysis

The first step consists of examining the application manifest.

Useful information includes:

- activities;
- services;
- broadcast receivers;
- permissions;
- exported components.

Typical workflow:

```bash
apktool d FactoryTest.apk
```

or

```bash
jadx-gui FactoryTest.apk
```

---

# Common Permissions

Factory utilities often request permissions such as:

- INTERNET
- CAMERA
- RECORD_AUDIO
- BLUETOOTH
- ACCESS_WIFI_STATE
- WRITE_SETTINGS
- READ_LOGS
- REBOOT (system applications)

The presence of these permissions reflects the application's diagnostic responsibilities rather than malicious intent.

---

# Hardware Interaction

Unlike ordinary Android applications, factory software frequently communicates directly with hardware services.

Examples include:

```text
Factory App

↓

Android Framework

↓

Vendor Service

↓

HAL

↓

Hardware Driver

↓

Physical Component
```

Typical hardware targets include:

- display engine;
- autofocus module;
- keystone correction;
- LEDs;
- Wi-Fi;
- Bluetooth;
- USB ports;
- storage devices.

---

# Startup Behavior

Some factory applications are launched only when explicitly requested.

Others may register boot receivers.

Typical sequence:

```text
BOOT_COMPLETED

↓

Broadcast Receiver

↓

Diagnostic Service

↓

Idle State
```

Runtime observation determines whether these applications remain active after boot.

---

# Runtime Analysis

Several commands assist with runtime inspection.

List running processes.

```bash
adb shell ps -A
```

Display services.

```bash
adb shell service list
```

Collect logs.

```bash
adb logcat
```

Monitor CPU usage.

```bash
adb shell top
```

These observations help determine whether an application actively participates in normal system operation.

---

# Reverse Engineering Workflow

The investigation followed a structured process.

```text
Identify Package

↓

Extract APK

↓

Analyze Manifest

↓

Review Permissions

↓

Inspect Decompiled Code

↓

Observe Runtime

↓

Map Hardware Dependencies

↓

Document Findings
```

This workflow separates static analysis from behavioral observations.

---

# Privileged Applications

Some testing utilities are installed as privileged system applications.

Characteristics include:

- access to protected APIs;
- communication with native services;
- interaction with hardware abstraction layers;
- elevated Android permissions.

Privileged status alone does not necessarily imply that the application is essential for normal device operation.

---

# Engineering Questions

Several questions guided the analysis.

- Does the application start automatically?
- Is it used only during manufacturing?
- Does it expose hidden engineering menus?
- Does it control hardware directly?
- Can it be safely removed?
- Does another service depend on it?

Each question was answered through observation rather than assumption.

---

# Dependency Analysis

Factory applications often depend upon other OEM components.

Example:

```text
Factory Application

↓

OEM Service

↓

Vendor Library

↓

HAL

↓

Hardware
```

Removing a seemingly unused diagnostic application may therefore have unintended consequences.

---

# Typical Findings

Factory applications generally fall into one of three categories.

| Category            | Typical Recommendation                    |
| ------------------- | ----------------------------------------- |
| Manufacturing Only  | Candidate for removal after validation    |
| Diagnostic Utility  | Preserve unless fully understood          |
| Hardware Controller | Preserve until dependencies are confirmed |

Classification should always be supported by reproducible evidence.

---

# Security Considerations

Because factory software may expose privileged functionality:

- engineering menus;
- hardware controls;
- diagnostic interfaces;
- service commands;

it deserves careful security evaluation.

However, diagnostic capability should not automatically be interpreted as a vulnerability.

Purpose and accessibility must both be considered.

---

# Common Challenges

Typical challenges include:

- undocumented package names;
- obfuscated code;
- native JNI libraries;
- proprietary communication protocols;
- hidden activities;
- disabled engineering interfaces.

Some functionality becomes visible only through runtime observation.

---

# Best Practices

When investigating factory applications:

- Preserve original APK files.
- Record installation paths.
- Compare behavior before and after removal tests.
- Validate dependencies.
- Document every hardware interaction.
- Treat privileged applications conservatively until fully understood.

---

# Summary

Factory and testing applications provide valuable insight into the engineering processes used during device manufacturing.

Although many appear inactive during normal operation, they frequently expose hardware interfaces, calibration procedures, and proprietary services that are useful during reverse engineering.

Systematically documenting these applications establishes a solid foundation before deciding whether any can be safely removed from a customized firmware.

---

# Next Chapter

Having examined factory applications, the investigation now turns to the component that defines the entire user experience:

the **OEM Launcher**.

The next chapter analyzes its architecture, startup sequence, dependencies, customization mechanisms, and interaction with Android's framework and proprietary projector services.

---

> [!IMPORTANT]
> Factory applications should never be dismissed simply because they are hidden from end users. They often reveal how the manufacturer validates hardware, initializes proprietary features, and structures the firmware—making them valuable sources of information during reverse engineering.