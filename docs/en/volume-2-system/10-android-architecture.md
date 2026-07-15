---
title: "Android Architecture"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Android Architecture

> *"To modify Android safely, one must first understand how its layers cooperate. Every component depends on another, and altering one layer without understanding the rest often leads to unpredictable behavior."*

---

# Introduction

Following the discovery phase presented in Volume 1, the investigation now shifts from observing the device to understanding its internal software architecture.

Although the HY300 projector runs a customized Android firmware, its overall architecture remains largely based on the Android Open Source Project (AOSP).

Understanding this architecture is essential before analyzing proprietary software, modifying partitions, or rebuilding firmware images.

This chapter introduces the software stack that powers the device and explains how the different layers interact during normal operation.

---

# Android as a Layered Operating System

Android is not a single monolithic application.

Instead, it is composed of multiple software layers built on top of the Linux kernel.

Each layer has a clearly defined role and communicates with the layers above and below it.

A simplified representation is shown below.

```text
+------------------------------------------------------+
|                  User Applications                   |
+------------------------------------------------------+
|              Android Application Framework           |
+------------------------------------------------------+
| Android Runtime (ART) & Native System Services       |
+------------------------------------------------------+
| Hardware Abstraction Layer (HAL)                     |
+------------------------------------------------------+
| Linux Kernel                                         |
+------------------------------------------------------+
| Hardware (Rockchip SoC, Memory, Storage, Peripherals)|
+------------------------------------------------------+
```

This layered design provides modularity, hardware abstraction, portability, and security.

---

# Layer 1 — Hardware

The foundation of every Android system is the hardware platform.

For the HY300 projector, this includes:

- Rockchip System-on-Chip (SoC)
- CPU
- GPU
- RAM
- eMMC storage
- Wi-Fi module
- Bluetooth controller
- HDMI interface
- USB controllers
- Projector-specific hardware

Every higher software layer ultimately interacts with these physical components.

---

# Layer 2 — Linux Kernel

Android relies on the Linux kernel for low-level operating system functionality.

The kernel is responsible for:

- process scheduling;
- virtual memory management;
- hardware drivers;
- interrupt handling;
- networking;
- power management;
- filesystem support;
- security primitives.

Unlike desktop Linux distributions, Android kernels typically include additional vendor-specific modifications.

---

# Layer 3 — Hardware Abstraction Layer (HAL)

The Hardware Abstraction Layer separates Android's higher-level software from hardware-specific implementations.

Rather than communicating directly with device drivers, Android services interact with standardized HAL interfaces.

Typical HAL modules include:

- camera
- audio
- graphics
- sensors
- Wi-Fi
- Bluetooth
- lights
- power management

Embedded projector devices often introduce additional proprietary HAL implementations for projector-specific features.

---

# Layer 4 — Android Runtime (ART)

Applications do not execute directly on the Linux kernel.

Instead, Android uses the Android Runtime (ART).

ART provides:

- managed application execution;
- memory management;
- garbage collection;
- bytecode execution;
- application isolation.

Native components continue to execute directly through shared libraries when required.

---

# Layer 5 — Native Libraries

Android includes numerous native libraries written primarily in C and C++.

Examples include:

- libc
- libbinder
- liblog
- OpenGL ES
- media framework libraries
- graphics libraries
- cryptographic libraries

Manufacturers frequently add proprietary libraries supporting hardware-specific functionality.

These libraries became an important focus of the reverse engineering effort.

---

# Layer 6 — Android Framework

The Android Framework provides the APIs used by applications.

Major framework services include:

- Package Manager
- Activity Manager
- Window Manager
- Power Manager
- Notification Manager
- Location Manager
- Display Manager

Applications communicate with these services using Binder IPC.

The Framework itself remains largely independent of the underlying hardware.

---

# Layer 7 — System Applications

System applications provide the user-facing operating environment.

Typical examples include:

- Launcher
- Settings
- File Manager
- Media applications
- Package Installer

OEM firmware usually replaces several standard applications with customized alternatives.

Understanding which applications are essential becomes increasingly important during firmware optimization.

---

# Binder IPC

One of Android's defining architectural features is Binder.

Binder is Android's primary Inter-Process Communication (IPC) mechanism.

Instead of allowing applications to communicate directly, Binder routes requests securely through the kernel.

Simplified communication flow:

```text
Application

↓

Binder

↓

System Service

↓

HAL

↓

Kernel Driver

↓

Hardware
```

This architecture improves security while maintaining modularity.

---

# Android Boot Relationship

The software layers become active progressively during system startup.

```text
Boot ROM

↓

Bootloader

↓

Linux Kernel

↓

init

↓

HAL

↓

System Services

↓

Android Framework

↓

Launcher

↓

User Applications
```

Each stage depends upon the successful initialization of the previous one.

---

# Security Boundaries

Android separates software into multiple security domains.

Examples include:

- application sandboxing;
- Linux user IDs;
- SELinux policies;
- Binder permissions;
- filesystem permissions;
- verified boot mechanisms.

These mechanisms collectively limit unauthorized access between applications and system components.

---

# Vendor Customization

Commercial Android devices rarely use a completely standard Android stack.

Manufacturers frequently introduce:

- custom launchers;
- proprietary applications;
- native daemons;
- vendor services;
- custom HAL implementations;
- hardware-specific libraries.

One objective of HY300 Ultimate is to identify these additions while preserving the stability of the underlying Android platform.

---

# Architecture in the HY300 Projector

The investigation identified a typical layered Android architecture supplemented by several proprietary OEM components.

```text
Applications

↓

OEM Launcher

↓

Android Framework

↓

OEM Services

↓

Vendor Libraries

↓

HAL

↓

Linux Kernel

↓

Rockchip Hardware
```

Understanding the interaction between these layers provides the foundation for every subsequent chapter.

---

# Architectural Principles

Several architectural principles remain consistent throughout Android.

| Principle             | Purpose                        |
| --------------------- | ------------------------------ |
| Layered Design        | Separation of responsibilities |
| Hardware Abstraction  | Device independence            |
| Binder IPC            | Secure communication           |
| Process Isolation     | Application security           |
| Modular Components    | Maintainability                |
| Native + Managed Code | Performance and flexibility    |

These principles explain why Android remains portable across many hardware platforms.

---

# Practical Implications for Reverse Engineering

Understanding Android architecture greatly simplifies firmware analysis.

It allows engineers to:

- locate proprietary modifications;
- distinguish AOSP components from OEM additions;
- identify critical system dependencies;
- understand boot failures;
- analyze native libraries;
- interpret log messages more accurately.

Without this architectural context, reverse engineering quickly becomes fragmented and difficult to maintain.

---

# Summary

This chapter introduced the fundamental architecture of Android and established the conceptual model used throughout the remainder of this documentation.

Although the HY300 projector contains numerous proprietary components, they are integrated into a software stack that remains largely consistent with standard Android architecture.

Understanding this layered design is essential before examining the boot process, partition organization, and vendor-specific software.

---

# Next Chapter

With the Android software architecture established, the next chapter examines the **Rockchip boot chain**.

Beginning at power-on, the investigation follows the complete startup sequence from Boot ROM to the Android Launcher, identifying where both standard Android components and proprietary OEM modifications are introduced.

---

> [!IMPORTANT]
> One of the central themes of the HY300 Ultimate project is distinguishing between standard Android behavior and manufacturer-specific customizations. A solid understanding of Android's architecture makes this distinction possible and prevents proprietary modifications from being mistaken for core operating system behavior.