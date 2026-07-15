---
title: "Keystone Update Pulse"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Keystone Update Pulse

> *"Image correction is not a one-time operation. A projector continuously evaluates whether its geometric model still matches the physical environment."*

---

# Introduction

The previous chapter described how Android properties participate in configuring the projector's keystone subsystem.

Configuration alone, however, is insufficient.

A projector must also determine **when** image correction needs to be recalculated.

This continuous synchronization process is referred to throughout this documentation as the **Keystone Update Pulse**.

Rather than representing a single executable component, the update pulse describes the sequence of events through which Android services, OEM software, and vendor libraries coordinate image geometry updates.

Understanding this workflow is essential before modifying any display-related firmware component.

---

# Objectives

This chapter investigates:

- how keystone updates are triggered;
- how runtime events propagate through Android;
- the interaction between OEM services and graphics components;
- synchronization with display rendering;
- projector-specific update logic;
- engineering considerations for firmware modification.

The objective is to document observable behavior without altering calibration algorithms.

---

# Why Continuous Updates Are Necessary

Unlike televisions or monitors, projectors operate in constantly changing environments.

Several events may require the displayed image to be recalculated.

Examples include:

- device movement;
- manual keystone adjustment;
- autofocus completion;
- display mode changes;
- HDMI source changes;
- application resolution changes.

The firmware therefore requires a mechanism capable of responding dynamically to these events.

---

# Event-Driven Architecture

Rather than continuously recalculating image geometry, Android typically relies on an event-driven workflow.

```text
User Action

↓

Android Event

↓

OEM Service

↓

Keystone Engine

↓

Graphics Pipeline

↓

Display Refresh
```

This minimizes unnecessary processing while maintaining a responsive user experience.

---

# Simplified Update Flow

The complete synchronization process can be represented as follows.

```text
Display Event

↓

Android Framework

↓

OEM Keystone Service

↓

Vendor Native Library

↓

Geometry Calculation

↓

SurfaceFlinger

↓

Hardware Composer

↓

Projection Engine
```

Every stage contributes to producing the corrected image shown to the user.

---

# Typical Update Triggers

Several events may initiate a geometry update.

| Trigger            | Possible Effect         |
| ------------------ | ----------------------- |
| Boot completed     | Initial correction      |
| Manual adjustment  | Immediate recalculation |
| Autofocus finished | Image refinement        |
| HDMI connected     | Display refresh         |
| Resolution change  | Geometry update         |
| Orientation change | Recalculation           |
| Display restart    | Full synchronization    |

The precise implementation depends on firmware design.

---

# Runtime Observation

The update sequence can be observed indirectly using Android diagnostic tools.

Useful commands include:

Collect system logs:

```bash
adb logcat
```

Inspect active services:

```bash
adb shell service list
```

Monitor running processes:

```bash
adb shell ps -A
```

Observe system properties:

```bash
adb shell getprop
```

Comparing system activity before and after user actions often reveals the update workflow.

---

# Interaction with Android Properties

Many projector parameters are exchanged through Android properties.

Simplified sequence:

```text
Property Change

↓

OEM Service

↓

Vendor Library

↓

Display Update
```

Properties therefore function primarily as a communication mechanism rather than implementing image correction directly.

---

# Synchronization with SurfaceFlinger

Once new geometry has been calculated, the display pipeline must render the corrected image.

```text
Updated Geometry

↓

Graphic Buffer

↓

SurfaceFlinger

↓

Hardware Composer

↓

Display Controller

↓

Projected Image
```

SurfaceFlinger remains responsible for composing the final display frame.

---

# Relationship with Autofocus

Automatic focus and keystone correction frequently operate together.

A simplified interaction model:

```text
Autofocus

↓

Image Analysis

↓

Keystone Update

↓

Display Refresh

↓

Stable Projection
```

Although implemented by separate components, both systems contribute to overall image quality.

---

# OEM Service Coordination

The update pulse generally involves several cooperating services.

```text
Android Framework

↓

Keystone Service

↓

Display Service

↓

Vendor Graphics Library

↓

Projection Hardware
```

No single component performs every operation independently.

---

# Native Processing

Geometry calculations are typically delegated to native libraries.

Possible responsibilities include:

- perspective transformation;
- coordinate mapping;
- matrix calculation;
- display synchronization;
- hardware communication.

These operations require significantly greater performance than would typically be expected from Java code alone.

---

# Reverse Engineering Workflow

The investigation followed a structured methodology.

```text
Observe Display Event

↓

Collect Runtime Logs

↓

Identify Service Activity

↓

Inspect Properties

↓

Map Graphics Pipeline

↓

Document Synchronization Flow
```

The emphasis remained on reproducible observations rather than speculative interpretation.

---

# Engineering Observations

Several conclusions emerged.

- Keystone updates are event-driven.
- Multiple Android components participate in the workflow.
- Native libraries perform most geometric calculations.
- SurfaceFlinger remains responsible for frame composition.
- Android properties facilitate communication between software layers.

These findings are consistent with the layered Android architecture documented in Volume 2.

---

# Common Challenges

Analyzing runtime synchronization introduces several difficulties.

Examples include:

- asynchronous events;
- proprietary vendor libraries;
- limited diagnostic logging;
- multiple cooperating services;
- undocumented Binder interfaces;
- hardware-specific timing behavior.

Consequently, no single observation fully explains the complete update process.

---

# Best Practices

When investigating runtime display updates:

- Record logs before and after each user action.
- Observe one event at a time.
- Compare multiple boot cycles.
- Separate graphics events from hardware events.
- Document every observed dependency.
- Validate conclusions through repeated observation.

---

# Relationship with Future Firmware Modifications

Understanding the update pulse is particularly valuable when:

- replacing OEM applications;
- modifying graphics libraries;
- rebuilding firmware;
- disabling proprietary services;
- troubleshooting display anomalies.

Without understanding synchronization, seemingly unrelated modifications may produce unexpected visual behavior.

---

# Summary

The **Keystone Update Pulse** represents the coordinated runtime process through which the HY300 firmware maintains correct image geometry.

Rather than relying on a single application or service, the firmware distributes responsibilities across Android properties, OEM services, native libraries, SurfaceFlinger, and projector hardware.

This layered architecture allows image correction to respond dynamically to changes while remaining integrated with Android's graphics pipeline.

---

# Next Chapter

With the keystone subsystem documented, the investigation now shifts toward the lower levels of the graphics stack.

The following chapter examines:

- **SurfaceFlinger**
- **librkgfx**
- hardware composition
- vendor graphics acceleration
- rendering pipeline
- projector display integration

These components form the graphical foundation upon which every projected image is ultimately rendered.

---

> [!IMPORTANT]
> Runtime synchronization should be viewed as a distributed process rather than a single function. Image correction emerges from the coordinated operation of Android events, OEM services, native graphics libraries, and the display pipeline, each contributing a specific role to the final projected image.