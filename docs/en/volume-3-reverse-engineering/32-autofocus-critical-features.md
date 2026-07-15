---
title: "Autofocus Critical Features"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Autofocus Critical Features

> *"Autofocus is one of the defining characteristics of a smart projector. It combines image analysis, hardware control, native processing, and real-time synchronization to continuously deliver a sharp projected image."*

---

# Introduction

Following the analysis of the graphics subsystem, JNI bridge, and keystone correction mechanisms, the investigation now focuses on one of the projector's most sophisticated hardware features:

**Autofocus.**

Unlike smartphones, where autofocus affects image capture, a projector continuously adjusts its optical system to ensure that the projected image remains sharp under changing installation conditions.

Achieving this requires close cooperation between Android services, native libraries, projector hardware, and proprietary firmware components.

This chapter documents the architecture of the autofocus subsystem and identifies the critical components involved in its operation.

---

# Objectives

The investigation aims to:

- identify autofocus-related services;
- understand the autofocus workflow;
- analyze communication between Android and native components;
- identify hardware dependencies;
- document synchronization with keystone correction;
- establish a baseline before firmware optimization.

No autofocus parameters were modified during this investigation.

---

# Autofocus Architecture

The autofocus subsystem can be represented as follows.

```text
Application

↓

OEM Autofocus Service

↓

ProjectUtils

↓

JNI

↓

Native Autofocus Library

↓

Motor Controller

↓

Projection Lens

↓

Projected Image
```

Each layer performs a dedicated role while remaining independent from higher-level Android applications.

---

# Why Autofocus Matters

Maintaining image sharpness requires continuous evaluation of projection quality.

Typical situations include:

- initial boot;
- projector movement;
- manual repositioning;
- automatic keystone adjustment;
- lens calibration;
- resolution changes.

The autofocus subsystem responds to these events by adjusting the optical assembly when necessary.

---

# Simplified Workflow

The overall autofocus sequence can be represented as:

```text
Boot

↓

Image Acquisition

↓

Sharpness Evaluation

↓

Focus Calculation

↓

Lens Adjustment

↓

Image Verification

↓

Projection Complete
```

This cycle may execute once or multiple times depending on environmental conditions.

---

# Main Components

The subsystem consists of several cooperating elements.

| Component           | Responsibility                   |
| ------------------- | -------------------------------- |
| Android Application | User interaction                 |
| Autofocus Service   | Coordinates autofocus operations |
| ProjectUtils        | Java-to-native bridge            |
| JNI                 | Native communication             |
| Native Library      | Focus algorithm                  |
| Motor Controller    | Lens movement                    |
| Optical System      | Physical image adjustment        |

No single component performs autofocus independently.

---

# Interaction with Keystone

Autofocus and keystone correction are closely related.

A simplified interaction model:

```text
Projector Movement

↓

Autofocus

↓

Keystone Calculation

↓

Graphics Pipeline

↓

Updated Projection
```

Although implemented separately, both subsystems contribute to the final image quality.

---

# Native Processing

The autofocus algorithm is typically implemented in native code.

Responsibilities may include:

- image sharpness evaluation;
- edge detection;
- contrast analysis;
- lens positioning;
- motor control;
- hardware communication.

Native execution provides deterministic performance suitable for real-time processing.

---

# Runtime Events

Autofocus may be triggered by several runtime events.

Examples include:

| Event                | Possible Action       |
| -------------------- | --------------------- |
| Boot completed       | Initial focusing      |
| Manual focus request | Lens adjustment       |
| Keystone update      | Focus verification    |
| HDMI connection      | Display validation    |
| Resolution change    | Re-evaluation         |
| Lens movement        | New focus calculation |

The firmware determines which events require recalibration.

---

# Service Coordination

The autofocus workflow depends on several Android services.

```text
Android Framework

↓

OEM Autofocus Service

↓

Vendor Native Library

↓

Motor Driver

↓

Lens Assembly
```

Coordination between services minimizes unnecessary lens movement while preserving image quality.

---

# Hardware Dependencies

Unlike ordinary Android applications, autofocus relies directly on hardware.

Typical dependencies include:

- lens actuator;
- focus motor;
- optical sensors (where present);
- image processing hardware;
- display controller.

These components are controlled through vendor-specific interfaces rather than standard Android APIs.

---

# Graphics Integration

Autofocus interacts indirectly with the graphics pipeline.

```text
Application

↓

SurfaceFlinger

↓

Display Output

↓

Projected Image

↓

Autofocus Evaluation

↓

Lens Correction
```

The displayed image becomes the reference used by the autofocus algorithm.

---

# Configuration

Autofocus parameters may originate from:

```text
Android Properties

↓

Vendor Configuration

↓

Native Library

↓

Runtime Calibration
```

Configuration files commonly reside in:

```text
/vendor/etc/

/product/etc/

/odm/etc/
```

Their exact format depends on firmware implementation.

---

# Runtime Observation

Useful diagnostic commands include:

Running services:

```bash
adb shell service list
```

Running processes:

```bash
adb shell ps -A
```

System logs:

```bash
adb logcat
```

System properties:

```bash
adb shell getprop
```

These commands allow autofocus activity to be observed without modifying the firmware.

---

# Reverse Engineering Workflow

The investigation followed a structured methodology.

```text
Identify Services

↓

Observe Boot

↓

Collect Runtime Logs

↓

Inspect JNI Calls

↓

Analyze Native Libraries

↓

Map Hardware Dependencies

↓

Document Findings
```

Static analysis and runtime observation complemented one another throughout the investigation.

---

# Engineering Observations

Several observations emerged.

- Autofocus depends heavily on native code.
- Android applications do not control the lens directly.
- ProjectUtils provides the Java-native bridge.
- Hardware communication is isolated within vendor libraries.
- Autofocus and keystone operate as complementary systems.

These observations are consistent with the layered architecture documented throughout this project.

---

# Common Challenges

Autofocus reverse engineering presents several challenges.

Examples include:

- proprietary image-processing algorithms;
- stripped native libraries;
- undocumented hardware interfaces;
- asynchronous motor control;
- vendor-specific calibration parameters;
- limited runtime logging.

Understanding behavior therefore requires both static analysis and live observation.

---

# Best Practices

When analyzing autofocus functionality:

- Preserve original firmware images.
- Record startup behavior.
- Observe autofocus under multiple operating conditions.
- Document JNI interactions.
- Separate hardware events from software events.
- Validate every conclusion through repeated observation.

---

# Relationship with Firmware Optimization

Because autofocus directly affects the user experience, modifications should be approached conservatively.

Understanding subsystem dependencies helps prevent:

- unstable image quality;
- excessive motor activity;
- synchronization issues;
- degraded projection performance.

Architectural understanding should always precede optimization.

---

# Summary

Autofocus is one of the most technically sophisticated subsystems within the HY300 firmware.

Rather than relying on a single application, it combines Android services, ProjectUtils, JNI, native libraries, hardware controllers, and projector optics into a coordinated real-time system.

The investigation demonstrates that autofocus is deeply integrated with the firmware architecture and closely linked to the graphics pipeline and keystone correction mechanisms.

---

# Next Chapter

The next chapter concludes **Volume 3** by summarizing the reverse engineering process applied to the HY300 OEM firmware.

It consolidates the major findings regarding:

- OEM applications;
- native daemons;
- launcher architecture;
- graphics pipeline;
- JNI communication;
- keystone correction;
- autofocus;
- proprietary services.

This conclusion establishes the foundation for **Volume 4**, where the investigation shifts from analysis to practical firmware reconstruction and customization.

---

> [!IMPORTANT]
> Autofocus should not be viewed as an isolated hardware feature. It is the result of coordinated interactions between Android services, native code, graphics processing, and projector-specific hardware. Understanding these relationships is essential before modifying any firmware component that may influence image quality.