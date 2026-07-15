---
title: "Keystone Properties"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Keystone Properties

> *"Keystone correction is one of the defining features of a modern smart projector. Behind a seemingly simple user interface lies a complex interaction between Android services, vendor libraries, graphics pipelines, and hardware-specific calibration parameters."*

---

# Introduction

One of the HY300 projector's most recognizable capabilities is **automatic keystone correction**.

Unlike standard Android devices, a projector must compensate for imperfect placement by adjusting the projected image geometry.

This functionality is implemented through a combination of:

- Android system properties;
- OEM services;
- vendor native libraries;
- graphics components;
- projector hardware.

Understanding these interactions is essential before modifying display-related firmware.

---

# Objectives

This chapter aims to:

- identify keystone-related Android properties;
- document the configuration workflow;
- understand interactions with OEM services;
- analyze property persistence;
- identify dependencies with graphics components;
- distinguish static configuration from runtime calibration.

No calibration values were modified during this investigation.

---

# What Is Keystone Correction?

Keystone correction compensates for image distortion caused by projecting onto a surface from an angle.

Instead of displaying a perfect rectangle:

```text
 ________
|        |
|        |
|________|
```

the projector may naturally produce:

```text
   ______
  /     /
 /     /
/_____/
```

The correction system transforms the image back into a rectangle through digital processing.

---

# Types of Keystone

Modern projectors generally support several correction modes.

| Mode                | Description                    |
| ------------------- | ------------------------------ |
| Vertical Keystone   | Corrects vertical distortion   |
| Horizontal Keystone | Corrects horizontal distortion |
| Four-Point Keystone | Independent corner adjustment  |
| Automatic Keystone  | Sensor-assisted correction     |
| Manual Keystone     | User-controlled adjustment     |

The available features depend on both hardware and firmware implementation.

---

# Android Properties

Android stores numerous runtime parameters as **system properties**.

Relevant properties can be inspected using:

```bash
adb shell getprop
```

Filtering projector-related entries:

```bash
adb shell getprop | grep -i key
```

or

```bash
adb shell getprop | grep -Ei "project|display|keystone"
```

Property names differ across firmware versions.

---

# Property Categories

Observed projector properties generally fall into several categories.

- display configuration;
- image geometry;
- hardware calibration;
- startup behavior;
- debugging;
- feature enablement.

Some properties remain constant throughout system operation, while others change dynamically.

---

# Runtime Configuration

The overall configuration flow can be represented as follows.

```text
Android Properties

↓

OEM Service

↓

Vendor Library

↓

Graphics Engine

↓

Projection Hardware
```

Properties themselves do not modify the image.

Instead, they provide configuration data consumed by native services.

---

# Persistence

Android properties may originate from several sources.

```text
build.prop

↓

Vendor Configuration

↓

System Properties

↓

Runtime Properties
```

Some values persist across reboots.

Others exist only while the system is running.

Understanding this distinction is important when analyzing firmware behavior.

---

# Inspecting Properties

Useful commands include:

Display all properties:

```bash
adb shell getprop
```

Display a specific property:

```bash
adb shell getprop <property_name>
```

Monitor changes:

```bash
adb shell watch getprop
```

Comparing property values before and after user actions often reveals runtime behavior.

---

# Interaction with OEM Services

Keystone functionality is rarely implemented entirely inside Android Framework components.

A simplified interaction model:

```text
Settings UI

↓

OEM Keystone Service

↓

Vendor Library

↓

Graphics Pipeline

↓

Projection Hardware
```

The Android property layer acts as a communication mechanism between components.

---

# Graphics Pipeline

Image correction is applied before the final frame reaches the projector.

```text
Application

↓

SurfaceFlinger

↓

Hardware Composer

↓

Vendor Graphics Library

↓

Keystone Engine

↓

Projection Output
```

This architecture allows correction to occur transparently for every application.

---

# Configuration Files

Besides Android properties, additional configuration may reside in:

```text
/vendor/etc/

/product/etc/

/odm/etc/

/system/etc/
```

Configuration files may contain:

- calibration parameters;
- default geometry;
- feature flags;
- hardware profiles.

Configuration should always be documented before experimentation.

---

# Reverse Engineering Workflow

The investigation followed a structured methodology.

```text
Identify Properties

↓

Capture Baseline

↓

Observe Runtime Changes

↓

Locate Configuration Files

↓

Identify Related Services

↓

Map Dependencies

↓

Document Findings
```

Only passive observation was performed during this stage.

---

# Dependency Graph

A simplified dependency model:

```text
Android Settings

↓

System Properties

↓

Keystone Service

↓

Vendor Library

↓

Graphics Driver

↓

Projection Engine
```

Understanding these relationships prevents incorrect assumptions regarding where image correction actually occurs.

---

# Engineering Observations

Several observations emerged.

- Android properties configure rather than implement keystone correction.
- Native services perform most hardware interaction.
- Graphics libraries participate in image transformation.
- Configuration is distributed across multiple software layers.
- Runtime observation complements static analysis.

---

# Common Challenges

Keystone analysis may be complicated by:

- undocumented property names;
- dynamically generated values;
- vendor-specific configuration files;
- native calibration libraries;
- proprietary hardware interfaces;
- multiple cooperating services.

Consequently, no single file fully describes the complete correction process.

---

# Best Practices

When investigating projector properties:

- Preserve original configuration files.
- Record complete property dumps.
- Compare values before and after configuration changes.
- Distinguish persistent from runtime properties.
- Document relationships between properties and services.
- Validate every observation across multiple reboots.

---

# Summary

Keystone correction on the HY300 projector relies on considerably more than a simple Android setting.

It represents a coordinated system involving Android properties, OEM services, vendor libraries, graphics components, and projector hardware.

Understanding these relationships establishes the architectural foundation for analyzing automatic calibration and image correction in the following chapters.

---

# Next Chapter

The next chapter investigates the **Keystone Update Pulse**, examining how the projector detects changes, triggers recalculation, and updates image geometry during runtime.

Topics include:

- automatic recalibration;
- update events;
- runtime synchronization;
- display refresh mechanisms;
- interaction with projector sensors and graphics services.

---

> [!IMPORTANT]
> Android properties should be viewed as configuration interfaces rather than processing engines. In the HY300 firmware, keystone correction results from the coordinated operation of multiple software layers, with system properties providing only one part of the overall control mechanism.