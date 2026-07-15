---
title: "Volume 3 Conclusions"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Volume 3 Conclusions

> *"Reverse engineering begins by understanding software as a system rather than as a collection of binaries. Every application, daemon, library, and service contributes to a coherent firmware architecture."*

---

# Introduction

Volume 3 marked the transition from Android platform architecture to the analysis of the proprietary software supplied with the HY300 firmware.

Where the previous volume focused on Android itself, this volume explored the manufacturer's customizations, revealing how OEM applications, native daemons, graphics libraries, and hardware abstraction layers cooperate to provide projector-specific functionality.

Rather than examining isolated binaries, the investigation documented how these components interact to form a complete embedded operating system.

---

# Objectives Achieved

The objectives established at the beginning of this volume have been successfully completed.

The investigation now provides documented knowledge of:

- OEM application inventory;
- firmware update mechanisms;
- factory utilities;
- launcher architecture;
- multimedia services;
- background daemons;
- native graphics libraries;
- JNI communication;
- keystone correction;
- autofocus architecture.

These findings establish a comprehensive understanding of the proprietary software layer.

---

# OEM Software Inventory

The investigation began by identifying every proprietary application included with the firmware.

Applications were classified according to their roles.

| Category             | Examples               |
| -------------------- | ---------------------- |
| System Interface     | OEM Launcher           |
| Firmware Maintenance | TXCZ                   |
| Factory Utilities    | Test Applications      |
| Connectivity         | QuickShare, USBDisplay |
| Hardware Services    | Keystone, Autofocus    |
| Native Components    | daemon12138            |

This inventory became the foundation for every subsequent reverse engineering activity.

---

# OTA Infrastructure

The TXCZ application illustrated how firmware updates integrate with Android.

The observed workflow consisted of:

```text
Update Request

↓

Version Verification

↓

Package Download

↓

Recovery

↓

Firmware Installation

↓

Android Boot
```

The investigation showed that firmware updates rely upon Android's existing update infrastructure while extending it through OEM-specific software.

---

# Factory Applications

Factory applications provided valuable insight into the manufacturer's production process.

These utilities exposed:

- diagnostic interfaces;
- hardware validation;
- calibration procedures;
- engineering tools;
- manufacturing workflows.

Although not always required during normal operation, they revealed important implementation details.

---

# OEM Launcher

The launcher proved to be significantly more than a graphical home screen.

Instead, it acts as the central coordinator for:

- projector settings;
- display controls;
- keystone adjustment;
- autofocus access;
- multimedia features;
- hardware integration.

Its architecture demonstrated how Android applications cooperate with proprietary native services.

---

# Connectivity Components

QuickShare and USBDisplay illustrated how the projector integrates external devices.

Simplified architecture:

```text
External Device

↓

OEM Application

↓

Android Media Framework

↓

SurfaceFlinger

↓

Graphics Stack

↓

Projection Hardware
```

These applications rely on Android's standard multimedia framework while extending it through vendor-specific implementations.

---

# daemon12138

One of the most significant discoveries was the identification of **daemon12138**.

The investigation established that the daemon:

- starts automatically during boot;
- is managed by Android `init`;
- remains persistent throughout operation;
- communicates with vendor components;
- executes as a native service.

Rather than assigning undocumented functionality, the project documented only behaviors supported by reproducible observations.

---

# Security Analysis

The daemon investigation also highlighted Android's layered security model.

```text
Linux Kernel

↓

SELinux

↓

Filesystem Permissions

↓

Native Service

↓

Vendor Libraries

↓

Hardware
```

The analysis emphasized that privilege alone does not imply security risk.

Meaningful conclusions require careful observation of actual behavior.

---

# Graphics Architecture

The graphics subsystem was documented from Android applications to the projector hardware.

```text
Application

↓

SurfaceFlinger

↓

Hardware Composer

↓

librkgfx

↓

Display Controller

↓

Projection Engine
```

Understanding this pipeline explains how every projected image is ultimately rendered.

---

# JNI and ProjectUtils

ProjectUtils demonstrated how Java applications interact with native code.

```text
Java Application

↓

ProjectUtils

↓

JNI

↓

Native Library

↓

HAL

↓

Hardware
```

This architectural boundary separates Android applications from performance-critical native implementations.

---

# Keystone Correction

The investigation showed that keystone correction is distributed across multiple software layers.

Responsibilities include:

- Android properties;
- OEM services;
- native libraries;
- graphics pipeline;
- projector hardware.

No single application performs image correction independently.

---

# Autofocus

Autofocus emerged as one of the firmware's most sophisticated subsystems.

Its architecture combines:

```text
Android Application

↓

Autofocus Service

↓

JNI

↓

Native Library

↓

Motor Controller

↓

Projection Lens
```

The subsystem operates in close coordination with keystone correction and graphics rendering.

---

# Engineering Methodology

Throughout the volume, a consistent methodology was maintained.

```text
Identify

↓

Observe

↓

Document

↓

Analyze

↓

Validate

↓

Correlate

↓

Document Again
```

Every conclusion was supported by observable evidence whenever possible.

---

# Key Engineering Principles

Several principles guided the reverse engineering process.

| Principle                          | Benefit                      |
| ---------------------------------- | ---------------------------- |
| Preserve original firmware         | Prevent irreversible changes |
| Observe before modifying           | Improve reliability          |
| Separate evidence from assumptions | Increase objectivity         |
| Validate runtime behavior          | Confirm static analysis      |
| Maintain detailed documentation    | Ensure reproducibility       |

These principles remain applicable throughout later firmware reconstruction.

---

# Knowledge Acquired

By the end of Volume 3, the project had documented:

- proprietary Android applications;
- OEM update infrastructure;
- native daemons;
- graphics architecture;
- JNI communication;
- vendor libraries;
- projector hardware integration;
- autofocus architecture;
- keystone workflow;
- runtime dependencies.

This represents the first complete architectural model of the proprietary firmware.

---

# Preparing for Firmware Reconstruction

Although this volume focused on analysis rather than modification, it established the technical foundation required for firmware customization.

The documented relationships between applications, services, native libraries, and hardware reduce the risks associated with later reconstruction.

Instead of modifying binaries blindly, future work can proceed with a clear understanding of firmware dependencies.

---

# Volume 3 Summary

| Topic                         | Status |
| ----------------------------- | :----: |
| OEM Application Inventory     |   ✅    |
| TXCZ OTA Analysis             |   ✅    |
| Factory Applications          |   ✅    |
| OEM Launcher                  |   ✅    |
| QuickShare & USBDisplay       |   ✅    |
| daemon12138 Discovery         |   ✅    |
| daemon12138 Persistence       |   ✅    |
| daemon12138 Security Analysis |   ✅    |
| Keystone Properties           |   ✅    |
| Keystone Update Pulse         |   ✅    |
| SurfaceFlinger & librkgfx     |   ✅    |
| ProjectUtils & JNI            |   ✅    |
| Autofocus Architecture        |   ✅    |

---

# Transition to Volume 4

With the OEM firmware now thoroughly understood, the investigation moves from **analysis** to **engineering**.

**Volume 4** focuses on practical firmware reconstruction and customization.

Topics include:

- APK extraction;
- decompilation and rebuilding;
- binary patching;
- firmware reconstruction;
- Git-based development workflows;
- validation strategies;
- release preparation.

The emphasis shifts from understanding the firmware to modifying it in a structured and reproducible manner.

---

# Final Thoughts

Reverse engineering the HY300 firmware revealed that the device is built upon a carefully layered architecture.

Android Framework components, proprietary applications, native daemons, graphics libraries, and hardware abstraction layers cooperate to provide features such as automatic keystone correction, autofocus, wireless projection, and firmware updates.

By documenting these relationships before attempting any modification, the project transformed firmware customization from a trial-and-error exercise into a disciplined engineering process grounded in observation, reproducibility, and architectural understanding.

---

> [!IMPORTANT]
> Successful firmware reconstruction begins long before the first binary is modified. It begins with a complete understanding of the software architecture, the interaction between components, and the dependencies that bind the operating system together. Volume 3 provides that foundation, enabling the engineering work presented in the following volume.