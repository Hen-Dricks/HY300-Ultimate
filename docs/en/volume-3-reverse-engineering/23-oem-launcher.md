---
title: "OEM Launcher"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# OEM Launcher

> *"The launcher is far more than a home screen. On embedded Android devices, it often becomes the central control interface for the entire product."*

---

# Introduction

After documenting the firmware inventory, OTA application, and factory utilities, the investigation turned to the **OEM Launcher**.

Unlike smartphones, where the launcher primarily provides a graphical interface for applications, embedded Android devices frequently use a customized launcher as the central user interface.

For the HY300 projector, the launcher appears to integrate multiple projector-specific functions, making it one of the most important proprietary applications in the firmware.

Understanding its architecture is therefore essential before considering customization or replacement.

---

# Objectives

The investigation pursued several objectives.

- Identify the launcher package.
- Understand its startup sequence.
- Analyze its interaction with Android.
- Identify projector-specific functionality.
- Map dependencies.
- Determine replacement feasibility.
- Document OEM customizations.

No modifications were performed during this phase.

---

# What Is an Android Launcher?

A launcher is an Android application that handles the **HOME** intent.

It is responsible for presenting the primary user interface after Android completes boot.

Typical responsibilities include:

- home screen;
- application launcher;
- wallpaper management;
- widget support;
- navigation;
- recent applications;
- shortcuts.

Embedded devices frequently extend these responsibilities considerably.

---

# Launcher Startup

Once Android finishes initializing the framework:

```text
Boot Completed

↓

System Server

↓

Package Manager

↓

Resolve HOME Intent

↓

OEM Launcher

↓

User Interface
```

The launcher becomes the first application visible to the user.

---

# Launcher Responsibilities on HY300

Unlike a standard Android launcher, the projector launcher appears to integrate:

- projection controls;
- HDMI management;
- keystone shortcuts;
- autofocus controls;
- settings integration;
- media shortcuts;
- network status;
- storage management.

This suggests that the launcher serves as both a graphical shell and a hardware control interface.

---

# Locating the Launcher

The launcher package can be identified using:

```bash
adb shell cmd package resolve-activity \
android.intent.action.MAIN
```

Alternative method:

```bash
adb shell pm list packages
```

Package location:

```bash
adb shell pm path <launcher_package>
```

These commands identify the APK responsible for handling the HOME intent.

---

# APK Structure

After extraction:

```text
OEMLauncher.apk

├── AndroidManifest.xml
├── classes.dex
├── resources.arsc
├── assets/
├── res/
├── lib/
└── META-INF/
```

Each component contributes different information during reverse engineering.

---

# Manifest Analysis

The manifest reveals important characteristics.

Typical areas of interest include:

- launcher activity;
- permissions;
- exported activities;
- broadcast receivers;
- background services;
- intent filters.

Typical intent declaration:

```xml
<category android:name="android.intent.category.HOME"/>
```

This identifies the application as a launcher.

---

# Runtime Architecture

A simplified interaction model:

```text
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

Projector Hardware
```

Unlike ordinary applications, the launcher frequently communicates with proprietary services.

---

# Launcher Components

The launcher commonly consists of:

```text
Launcher

├── Main Activity
├── Settings
├── Widgets
├── HDMI Interface
├── Projection Controls
├── Media Browser
├── Network UI
└── Update Shortcut
```

Actual implementation varies by firmware version.

---

# Startup Dependencies

The launcher generally depends on several Android services.

Examples include:

- Activity Manager;
- Window Manager;
- Package Manager;
- Display Manager;
- Power Manager;
- OEM hardware services.

Failure of one dependency may prevent the launcher from functioning correctly.

---

# Hardware Integration

The HY300 launcher appears closely integrated with projector-specific features.

Simplified architecture:

```text
Launcher

↓

Keystone Service

↓

Autofocus Service

↓

Display Service

↓

Projection Engine
```

These dependencies explain why replacing the launcher without analysis can disable important hardware functionality.

---

# Resource Analysis

The APK resources frequently contain:

- layouts;
- icons;
- themes;
- localized strings;
- animations;
- configuration files.

Extraction example:

```bash
apktool d OEMLauncher.apk
```

Resource analysis provides insight into supported features without executing the application.

---

# Decompiled Code

Static analysis focuses on:

- activities;
- fragments;
- service bindings;
- Binder communication;
- JNI calls;
- native libraries;
- hardware APIs.

Example tool:

```bash
jadx-gui OEMLauncher.apk
```

Static analysis is complemented by runtime observation.

---

# Runtime Observation

Useful commands include:

Running processes:

```bash
adb shell ps -A
```

Current activity:

```bash
adb shell dumpsys activity
```

Log output:

```bash
adb logcat
```

These commands reveal how the launcher behaves during normal operation.

---

# Dependency Mapping

The launcher rarely operates alone.

```text
Launcher

↓

Projector Service

↓

Vendor Library

↓

HAL

↓

Kernel Driver
```

Understanding these dependencies is essential before attempting replacement.

---

# Reverse Engineering Workflow

The investigation followed a structured methodology.

```text
Identify Launcher

↓

Extract APK

↓

Analyze Manifest

↓

Inspect Resources

↓

Review Decompiled Code

↓

Observe Runtime

↓

Map Dependencies

↓

Document Findings
```

This workflow minimizes unsupported assumptions.

---

# Replacement Considerations

Replacing an OEM launcher is technically possible on many Android devices.

However, several questions must first be answered.

- Which proprietary APIs does it use?
- Does it launch hardware services?
- Does it initialize projector functions?
- Does another application depend on it?
- Does it expose hidden engineering menus?

Only after answering these questions can replacement be evaluated safely.

---

# Engineering Observations

Several conclusions emerged.

- The launcher is significantly more complex than a standard home screen.
- It interacts closely with proprietary services.
- Hardware functionality appears integrated into its workflow.
- Static analysis alone is insufficient.
- Runtime observation is necessary to understand behavior.

---

# Common Challenges

Typical launcher reverse engineering challenges include:

- obfuscated Java classes;
- native JNI libraries;
- undocumented Binder interfaces;
- hidden activities;
- vendor-specific permissions;
- proprietary hardware APIs.

These require both static and dynamic analysis.

---

# Best Practices

When analyzing an OEM launcher:

- Preserve the original APK.
- Record launcher startup logs.
- Document every exported activity.
- Identify hardware dependencies.
- Analyze resources before modifying code.
- Test replacements only after dependency mapping.

---

# Summary

The OEM Launcher represents the primary interface between the user and the projector.

Far from being a simple home screen, it coordinates Android framework services with proprietary projector functionality, making it one of the most critical applications in the firmware.

Understanding its architecture, dependencies, and startup behavior provides the foundation for later customization and optimization.

---

# Next Chapter

The next chapter investigates two additional OEM applications that extend the projector's connectivity features:

- **QuickShare**
- **USBDisplay**

These components provide screen sharing and external display functionality and illustrate how the manufacturer integrates Android networking, multimedia services, and proprietary projection technologies.

---

> [!IMPORTANT]
> On embedded Android devices, the launcher should be viewed as a system orchestrator rather than merely a graphical interface. Before replacing or modifying it, engineers should fully understand every service, library, and hardware feature it coordinates to avoid unintentionally disabling core device functionality.