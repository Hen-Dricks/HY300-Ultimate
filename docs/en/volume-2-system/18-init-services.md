---
title: "Android init and System Services"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Android init and System Services

> *"Once the Linux kernel has completed its work, Android truly begins with a single process: init. Every service, every application, and every system component ultimately traces its origin back to this first userspace process."*

---

# Introduction

After the Linux kernel initializes the hardware and mounts the required filesystems, control is transferred to Android's first userspace process:

```text
init
```

Unlike a traditional Linux distribution using **systemd** or **SysVinit**, Android relies on its own initialization system.

The Android `init` process is responsible for preparing the operating system before the user ever sees the launcher.

Understanding `init` is essential because nearly every proprietary OEM customization observed in the HY300 firmware is introduced during this phase.

---

# The Role of init

`init` is process **PID 1**.

Every other userspace process is created directly or indirectly by it.

Its primary responsibilities include:

- parsing initialization scripts;
- mounting filesystems;
- applying system properties;
- configuring SELinux;
- starting native daemons;
- launching Android services;
- monitoring critical services;
- restarting failed services when required.

Without `init`, Android cannot complete its startup sequence.

---

# Android Startup Sequence

The following diagram illustrates where `init` appears within the boot chain.

```text
Power On

↓

Bootloader

↓

Linux Kernel

↓

init (PID 1)

↓

Filesystem Mount

↓

SELinux Initialization

↓

Native Services

↓

Android Framework

↓

Launcher

↓

Applications
```

---

# init Configuration Files

Android initialization is driven by several configuration files.

Typical examples include:

```text
init.rc

init.environ.rc

init.<hardware>.rc

ueventd.rc

fstab.<device>
```

OEM firmware often adds additional configuration files for proprietary hardware.

These scripts determine which services start and under which conditions.

---

# init.rc

The primary initialization file is typically named:

```text
init.rc
```

It defines:

- startup actions;
- service declarations;
- permissions;
- filesystem operations;
- property triggers.

A simplified example:

```text
service logd /system/bin/logd
    class core
    user logd
    group log
```

---

# Service Classes

Android groups services into logical classes.

Common examples include:

| Class      | Purpose                     |
| ---------- | --------------------------- |
| core       | Essential system services   |
| main       | Android runtime services    |
| late_start | Services started after boot |
| animation  | Boot animation              |

Service classes simplify startup ordering.

---

# Android Properties

During initialization, Android loads hundreds of system properties.

Examples:

```bash
adb shell getprop
```

Specific property:

```bash
adb shell getprop ro.build.version.release
```

Properties influence:

- hardware configuration;
- debugging;
- networking;
- graphics;
- OEM features.

---

# Property Triggers

Unlike traditional Linux init systems, Android can react dynamically to property changes.

Example:

```text
on property:sys.boot_completed=1
```

This allows services to start only after specific system events occur.

Property triggers play an important role in OEM firmware customization.

---

# Native Services

Once the initial environment has been prepared, Android starts numerous native services.

Examples include:

```text
adbd

logd

vold

servicemanager

hwservicemanager

installd

surfaceflinger
```

These services provide the foundation upon which the Android Framework operates.

---

# Service Lifecycle

Every service progresses through several states.

```text
Declared

↓

Started

↓

Running

↓

Restarted (if required)

↓

Stopped
```

Critical services may be restarted automatically if they terminate unexpectedly.

---

# Inspecting Running Services

Several commands are useful during analysis.

List running processes.

```bash
adb shell ps -A
```

Display Android services.

```bash
adb shell service list
```

Display active properties.

```bash
adb shell getprop
```

Collect startup logs.

```bash
adb logcat
```

These commands formed an important part of the HY300 investigation.

---

# OEM Services

One of the primary goals of this project was identifying proprietary services added by the manufacturer.

Typical examples included:

- keystone management;
- autofocus control;
- projector calibration;
- update services;
- hardware monitoring;
- launcher integration.

Unlike standard Android services, these components often lack public documentation.

---

# Service Dependencies

Services rarely operate independently.

A simplified dependency chain:

```text
init

↓

servicemanager

↓

System Services

↓

OEM Services

↓

Applications
```

Understanding these relationships is essential before disabling or replacing any component.

---

# Service Monitoring

Android continuously monitors critical services.

If an essential daemon terminates unexpectedly:

```text
Service Crash

↓

init Detects Failure

↓

Restart Service

↓

Continue Operation
```

Repeated failures may eventually trigger a reboot or boot loop.

---

# SELinux Integration

Service startup is tightly integrated with SELinux.

Each service executes within a predefined security domain.

Simplified workflow:

```text
Start Service

↓

Apply SELinux Context

↓

Launch Process

↓

Enforce Security Policy
```

Incorrect service configuration frequently results in SELinux denials.

---

# HY300 Investigation

During firmware analysis, particular attention was paid to:

- startup order;
- proprietary daemons;
- custom property triggers;
- OEM services;
- launcher initialization;
- hardware initialization sequence.

Every identified service was documented before any modifications were considered.

---

# Engineering Workflow

The investigation followed a disciplined methodology.

```text
Inspect init Scripts

↓

List Running Services

↓

Identify OEM Components

↓

Monitor Startup

↓

Analyze Dependencies

↓

Document Findings
```

Only after understanding the service architecture did reverse engineering proceed to deeper binary analysis.

---

# Common Problems

Typical service-related issues include:

| Symptom                  | Possible Cause                |
| ------------------------ | ----------------------------- |
| Boot loop                | Critical service failure      |
| Missing functionality    | Service not started           |
| Continuous restarts      | Invalid configuration         |
| SELinux denials          | Incorrect security context    |
| High CPU usage           | Misbehaving background daemon |
| Missing hardware feature | Vendor service unavailable    |

Recognizing these symptoms simplifies troubleshooting considerably.

---

# Best Practices

When analyzing Android services:

- Never disable multiple services simultaneously.
- Record the original startup sequence.
- Monitor `logcat` during boot.
- Document every proprietary daemon.
- Verify service dependencies before modification.
- Distinguish standard Android services from OEM additions.

---

# Summary

The Android `init` process orchestrates the entire userspace startup sequence.

From mounting filesystems and loading system properties to launching native daemons and OEM services, `init` is responsible for transforming a running Linux kernel into a fully operational Android system.

For the HY300 Ultimate project, understanding this initialization process provided the foundation for identifying proprietary manufacturer components and determining where custom firmware modifications could be introduced safely.

---

# Next Chapter

With Android's initialization process now fully understood, the second volume concludes by summarizing the architecture explored so far.

The final chapter consolidates the major discoveries regarding:

- Android architecture;
- Rockchip boot sequence;
- partition organization;
- dynamic partitions;
- filesystem mounting;
- memory management;
- system initialization.

These concepts provide the architectural foundation for **Volume 3**, where the investigation shifts from understanding Android to reverse engineering the proprietary software supplied by the manufacturer.

---

> [!IMPORTANT]
> In Android, every application begins with the launcher, every framework service begins with the system server, and every one of those ultimately begins with `init`. Understanding `init` means understanding the point at which the operating system itself comes to life.