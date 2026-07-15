---
title: "Discovery of daemon12138"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Discovery of daemon12138

> *"Some of the most influential components of an embedded Android system have no user interface at all. They execute silently, persist throughout the system lifetime, and often reveal the manufacturer's internal architecture."*

---

# Introduction

During the inventory of OEM applications and native services, one component immediately attracted attention:

```text
daemon12138
```

Unlike user applications or Android framework services, this executable runs entirely in the background.

It presents no graphical interface, no launcher icon, and no obvious configuration menu.

Nevertheless, runtime observations showed that it is consistently started during the Android boot sequence, indicating that it plays an important role within the OEM firmware.

This chapter documents the discovery process, identifies the daemon's position within the system, and establishes the foundation for its detailed analysis in the following chapters.

---

# Objectives

The discovery phase pursued several objectives.

- Identify the daemon executable.
- Determine where it is stored.
- Verify how it starts.
- Observe its runtime behavior.
- Determine whether it is persistent.
- Identify immediate dependencies.
- Document evidence before modification.

No attempt was made to disable or alter the daemon during this stage.

---

# What Is a Daemon?

A daemon is a background process that executes without direct user interaction.

Typical Android daemons provide services such as:

- logging;
- networking;
- storage management;
- graphics;
- hardware communication;
- media processing.

Unlike Android applications, daemons usually start during system initialization and continue running until shutdown.

---

# Initial Observation

The daemon was first identified while inspecting active processes.

Example:

```bash
adb shell ps -A
```

or

```bash
adb shell pidof daemon12138
```

Its presence immediately after boot suggested that it was launched automatically rather than manually by the user.

---

# Locating the Executable

The executable location can be determined using:

```bash
adb shell which daemon12138
```

or

```bash
adb shell find / -name "*daemon12138*" 2>/dev/null
```

Typical locations include:

```text
/system/bin/

/vendor/bin/

/system_ext/bin/

/product/bin/
```

The installation path often provides clues regarding ownership and responsibilities.

---

# Startup Sequence

The daemon appears during the early stages of Android initialization.

Simplified sequence:

```text
Bootloader

↓

Linux Kernel

↓

init

↓

Native Services

↓

daemon12138

↓

OEM Services

↓

Launcher
```

Its position suggests that it participates in low-level system initialization rather than user-facing functionality.

---

# Identifying the Parent Process

Every Android daemon originates from `init`.

Verification:

```bash
adb shell ps -A -o PID,PPID,NAME
```

Typical relationship:

```text
init (PID 1)

↓

daemon12138
```

This confirms that the daemon is started by Android's initialization system.

---

# Monitoring Runtime

The daemon's behavior can be observed using:

```bash
adb logcat
```

and

```bash
adb shell top
```

Useful observations include:

- CPU usage;
- memory consumption;
- process lifetime;
- restart behavior;
- log output.

At this stage, only passive observation was performed.

---

# Service Registration

The investigation examined whether the daemon was declared as an Android service.

Relevant files include:

```text
init.rc

init.<device>.rc

vendor/etc/init/

system/etc/init/
```

Searching configuration files:

```bash
grep -R "daemon12138" .
```

This helps identify how Android launches the executable during boot.

---

# Binary Inspection

Without modifying the executable, preliminary information can be collected.

Example:

```bash
file daemon12138
```

Determine architecture:

```bash
readelf -h daemon12138
```

List shared libraries:

```bash
readelf -d daemon12138
```

Display printable strings:

```bash
strings daemon12138
```

These commands provide valuable metadata before deeper reverse engineering.

---

# Runtime Dependencies

The daemon does not operate independently.

Initial observations suggest interactions with:

- Android system properties;
- vendor libraries;
- native services;
- hardware abstraction layers;
- projector-specific components.

The exact relationships are examined in later chapters.

---

# Communication Model

A simplified interaction model:

```text
init

↓

daemon12138

↓

Vendor Libraries

↓

HAL

↓

Projector Hardware
```

The daemon therefore appears to act as an intermediary between Android userspace and proprietary hardware services.

---

# Why It Stood Out

Several characteristics distinguished daemon12138 from ordinary background services.

Examples include:

- automatic startup;
- persistent execution;
- native executable;
- absence of user interface;
- OEM-specific naming;
- interaction with hardware-related components.

These characteristics justified a dedicated investigation.

---

# Reverse Engineering Workflow

The discovery phase followed a structured methodology.

```text
Identify Process

↓

Locate Executable

↓

Determine Startup Method

↓

Inspect Binary Metadata

↓

Observe Runtime

↓

Document Findings

↓

Prepare Detailed Analysis
```

Only observational techniques were used.

---

# Engineering Observations

Several conclusions emerged.

- The daemon is started automatically.
- It appears to be a native executable.
- It is integrated into Android initialization.
- It likely supports projector-specific functionality.
- Runtime observation is essential before attempting modification.

These conclusions remain preliminary until supported by deeper analysis.

---

# Common Challenges

Native daemons often present challenges such as:

- stripped binaries;
- proprietary protocols;
- undocumented configuration;
- JNI integration;
- limited logging;
- OEM-specific naming conventions.

Consequently, binary inspection alone rarely provides a complete understanding.

---

# Best Practices

When investigating native daemons:

- Preserve the original executable.
- Calculate SHA-256 hashes.
- Observe runtime before static analysis.
- Record startup order.
- Identify configuration files.
- Separate confirmed observations from hypotheses.

---

# Summary

The discovery of **daemon12138** marked one of the most significant milestones of the OEM firmware investigation.

Although its purpose was not yet fully understood, its automatic startup, persistent execution, and integration with Android initialization clearly indicated that it was more than an ordinary background process.

This chapter establishes the factual baseline required for the more detailed persistence and security analyses that follow.

---

# Next Chapter

Having identified the daemon and documented its startup behavior, the next chapter investigates **how daemon12138 achieves persistence**.

Topics include:

- init integration;
- startup scripts;
- service declarations;
- restart policies;
- property triggers;
- lifecycle management.

Understanding these mechanisms explains why the daemon remains active throughout normal system operation.

---

> [!IMPORTANT]
> The discovery phase deliberately avoids assigning functionality to a component based solely on its name or location. In reverse engineering, the existence of a process is an observation; its purpose must be established through reproducible evidence gathered from static analysis, runtime behavior, configuration files, and documented system interactions.