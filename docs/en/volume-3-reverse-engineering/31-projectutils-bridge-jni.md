---
title: "ProjectUtils and the JNI Bridge"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# ProjectUtils and the JNI Bridge

> *"Android applications rarely communicate directly with hardware. Between Java and native code lies one of Android's most important interfaces: the Java Native Interface (JNI)."*

---

# Introduction

During the analysis of the HY300 firmware, several OEM applications referenced a component commonly named **ProjectUtils**.

Unlike graphical applications such as the launcher or media player, ProjectUtils appears to function as an intermediary between Java-based Android applications and native projector services.

Rather than implementing hardware functionality itself, ProjectUtils exposes a collection of utility methods that allow Android applications to invoke native code through the **Java Native Interface (JNI)**.

Understanding this bridge is essential because many projector-specific features—including keystone correction, autofocus, display configuration, and hardware management—ultimately rely on communication between managed Java code and native vendor libraries.

---

# Objectives

This chapter aims to:

- identify the role of ProjectUtils;
- explain the Java Native Interface (JNI);
- analyze the bridge between Android applications and native code;
- identify native libraries involved;
- understand data flow;
- document dependencies;
- establish the foundation for later native library analysis.

No native libraries were modified during this investigation.

---

# What Is JNI?

JNI (Java Native Interface) is the official mechanism allowing Java code running inside Android Runtime (ART) to invoke native C or C++ code.

Instead of implementing hardware functionality directly, Android applications frequently delegate low-level operations to native libraries.

Simplified architecture:

```text
Java Application

↓

JNI

↓

Native Library (.so)

↓

HAL

↓

Kernel Driver

↓

Hardware
```

This separation combines Java's portability with the performance of native code.

---

# Why OEMs Use JNI

Projector manufacturers frequently implement hardware-specific functionality in native code because it provides:

- improved performance;
- direct hardware access;
- reuse of existing C/C++ code;
- easier integration with vendor SDKs;
- reduced Java framework complexity.

ProjectUtils serves as a convenient abstraction layer hiding this complexity from Android applications.

---

# Role of ProjectUtils

ProjectUtils typically provides utility methods such as:

- projector configuration;
- display management;
- hardware status retrieval;
- image adjustment;
- device information;
- native service communication.

Applications call ProjectUtils rather than interacting directly with native libraries.

---

# Simplified Architecture

```text
OEM Application

↓

ProjectUtils

↓

JNI

↓

Native Library

↓

Vendor Service

↓

HAL

↓

Projection Hardware
```

This layered approach improves modularity while keeping hardware-specific logic inside native components.

---

# Identifying JNI Methods

JNI methods are generally declared in Java using the `native` keyword.

Example:

```java
public native int getProjectorStatus();

public native void setKeystone(int value);

public native boolean enableAutoFocus();
```

The Java implementation contains no executable code.

Execution is delegated entirely to the corresponding native library.

---

# Native Library Loading

JNI libraries are usually loaded during application startup.

Example:

```java
static {
    System.loadLibrary("projectutils");
}
```

This instructs Android Runtime to load:

```text
libprojectutils.so
```

from the application's native library directory.

---

# Native Libraries

Typical libraries encountered include:

```text
libprojectutils.so

librkgfx.so

libnativehelper.so

libc++.so
```

Additional vendor libraries may also be present depending on the firmware version.

---

# APK Structure

Simplified example:

```text
ProjectUtils.apk

├── AndroidManifest.xml
├── classes.dex
├── lib/
│   ├── arm64-v8a/
│   │      └── libprojectutils.so
│   └── armeabi-v7a/
└── res/
```

The `lib/` directory contains the native components used through JNI.

---

# Data Flow

A typical JNI interaction follows this sequence.

```text
Java Method

↓

JNI Wrapper

↓

Native Function

↓

Vendor Library

↓

Hardware Service

↓

Response

↓

Java Application
```

Each layer performs a specific role while maintaining a clear separation between managed and native execution environments.

---

# JNI Registration

Native functions may be registered in one of two ways.

## Static Registration

Method names follow the JNI naming convention.

Example:

```text
Java_com_vendor_ProjectUtils_setKeystone
```

---

## Dynamic Registration

Functions are registered during library initialization.

Typical entry point:

```text
JNI_OnLoad()
```

Dynamic registration is common in commercial Android firmware because it offers greater flexibility and reduces symbol visibility.

---

# Inspecting Native Libraries

Several tools provide useful metadata.

Determine file type:

```bash
file libprojectutils.so
```

Display exported symbols:

```bash
nm -D libprojectutils.so
```

Inspect ELF information:

```bash
readelf -h libprojectutils.so
```

Display printable strings:

```bash
strings libprojectutils.so
```

These techniques are entirely non-destructive.

---

# Reverse Engineering Workflow

The investigation followed a structured methodology.

```text
Locate APK

↓

Extract Native Libraries

↓

Inspect JNI Methods

↓

Analyze Exported Symbols

↓

Map Java Calls

↓

Observe Runtime

↓

Document Dependencies
```

Both static and runtime observations were maintained separately.

---

# Interaction with OEM Services

ProjectUtils does not generally communicate directly with hardware.

Instead, it acts as a bridge.

```text
OEM Application

↓

ProjectUtils

↓

JNI

↓

Vendor Service

↓

HAL

↓

Projection Hardware
```

This architecture keeps Java applications independent of hardware implementation details.

---

# Runtime Observation

Useful commands include:

Running processes:

```bash
adb shell ps -A
```

Runtime logs:

```bash
adb logcat
```

Library inspection:

```bash
adb shell ls /system/lib64

adb shell ls /vendor/lib64
```

Observing library loading during startup often reveals additional dependencies.

---

# Engineering Observations

Several conclusions emerged.

- ProjectUtils functions primarily as an abstraction layer.
- JNI separates Java code from hardware-specific implementations.
- Most projector functionality ultimately depends on native libraries.
- Hardware access remains concentrated below the Android Framework.
- Native analysis is necessary to fully understand OEM behavior.

---

# Common Challenges

JNI reverse engineering introduces several difficulties.

Examples include:

- stripped native libraries;
- dynamically registered methods;
- C++ name mangling;
- proprietary APIs;
- undocumented vendor SDKs;
- multiple interconnected shared libraries.

For this reason, Java decompilation alone rarely provides a complete understanding.

---

# Best Practices

When analyzing JNI components:

- Preserve original APKs and libraries.
- Identify every loaded shared library.
- Document JNI registration methods.
- Map Java methods to native functions.
- Separate confirmed behavior from inferred functionality.
- Combine static analysis with runtime observation.

---

# Summary

ProjectUtils represents a key architectural bridge within the HY300 firmware.

Rather than implementing projector functionality directly, it provides a structured interface through which Android applications communicate with native libraries using JNI.

This separation improves modularity while allowing performance-critical hardware operations to remain implemented in optimized native code.

Understanding this bridge establishes the foundation for analyzing the native libraries responsible for projector-specific features.

---

# Next Chapter

The following chapter examines one of the most visible hardware capabilities of the HY300 projector:

**Autofocus**.

The investigation explores:

- autofocus architecture;
- image analysis;
- hardware interaction;
- native services;
- runtime synchronization;
- dependencies with keystone correction and the graphics pipeline.

Together, these analyses complete the reverse engineering of the projector's primary hardware control subsystems.

---

> [!IMPORTANT]
> JNI should be viewed as an architectural boundary rather than merely a programming interface. In the HY300 firmware, it separates platform-independent Android applications from proprietary native implementations, making it one of the most important layers for understanding how OEM software ultimately interacts with projector hardware.