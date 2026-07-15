---
title: "Memory Management, ZRAM and Swap"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Memory Management, ZRAM and Swap

> *"On embedded Android devices, performance is often determined less by processor speed than by how efficiently memory is managed."*

---

# Introduction

Modern Android devices continuously manage memory to ensure that applications remain responsive while limited hardware resources are used efficiently.

Unlike desktop operating systems, Android is designed to operate within strict memory constraints, particularly on embedded devices such as projectors, TV boxes, and IoT platforms.

The HY300 projector is no exception.

Understanding how Android allocates RAM, compresses memory with **ZRAM**, and manages low-memory situations is essential before attempting any performance optimization.

---

# Android Memory Architecture

Android memory management combines several components.

```text
                Applications
                     │
                     ▼
          Android Runtime (ART)
                     │
                     ▼
        Activity & Process Manager
                     │
                     ▼
       Low Memory Management (LMKD)
                     │
                     ▼
        ZRAM / Physical RAM / Swap
                     │
                     ▼
               Linux Kernel
```

Every layer contributes to maintaining a balance between performance and resource availability.

---

# Physical RAM

RAM is the fastest storage available to Android.

It is used for:

- running applications;
- system services;
- graphics buffers;
- caches;
- kernel structures;
- temporary data.

Unlike storage, RAM is volatile and is cleared every time the device reboots.

---

# Memory Allocation

Android dynamically allocates memory according to process priority.

Simplified hierarchy:

```text
Foreground App

↓

Visible App

↓

Background Service

↓

Cached Process

↓

Empty Process
```

Processes with higher priority are preserved whenever possible.

Lower-priority processes may be terminated to reclaim memory.

---

# Low Memory Killer Daemon (LMKD)

Android no longer relies solely on the traditional Linux Out-Of-Memory (OOM) killer.

Instead, modern versions use the **Low Memory Killer Daemon (LMKD)**.

Responsibilities include:

- monitoring available memory;
- predicting memory pressure;
- terminating cached processes;
- preventing system-wide OOM conditions.

This improves responsiveness while reducing sudden application crashes.

---

# Cached Processes

Applications that are no longer actively used are not immediately terminated.

Instead, Android places them into a cached state.

Benefits include:

- faster application relaunch;
- reduced CPU usage;
- improved user experience.

Cached applications become candidates for termination only when additional memory is required.

---

# What Is ZRAM?

**ZRAM** is a compressed block device located entirely in RAM.

Instead of writing inactive memory pages to physical storage, Android compresses them and stores them in memory.

Simplified model:

```text
RAM

↓

Compress Memory Pages

↓

ZRAM

↓

More Available Memory
```

This approach is significantly faster than swapping to flash storage.

---

# Why ZRAM?

Embedded devices often have limited physical RAM.

ZRAM provides:

- better multitasking;
- reduced application reloads;
- lower storage wear;
- improved responsiveness;
- efficient use of available memory.

For devices with modest RAM capacity, ZRAM often delivers a noticeable performance improvement.

---

# Compression Workflow

```text
Application

↓

Inactive Memory Page

↓

Compression

↓

Stored in ZRAM

↓

Decompressed When Needed
```

Compression introduces a small CPU cost but generally saves considerably more memory than it consumes.

---

# Swap

Traditional Linux systems frequently use swap partitions stored on disk.

Android generally avoids conventional swap on internal flash storage because repeated writes increase storage wear.

Possible memory hierarchy:

```text
Physical RAM

↓

ZRAM

↓

Disk Swap (rare)

↓

OOM Killer
```

Most embedded Android devices rely primarily on ZRAM rather than permanent swap partitions.

---

# Inspecting Memory Usage

Display memory information.

```bash
adb shell cat /proc/meminfo
```

Display memory statistics.

```bash
adb shell free -h
```

Display running processes.

```bash
adb shell top
```

Display virtual memory statistics.

```bash
adb shell vmstat
```

These commands provide a good overview of runtime memory usage.

---

# Inspecting ZRAM

Verify ZRAM configuration.

```bash
adb shell cat /proc/swaps
```

Display block devices.

```bash
adb shell ls /sys/block
```

Inspect ZRAM statistics.

```bash
adb shell cat /sys/block/zram0/mm_stat
```

Different Android versions may expose slightly different statistics.

---

# Memory Pressure

When available memory decreases, Android follows a predictable strategy.

```text
Available RAM

↓

Cached Processes

↓

ZRAM Compression

↓

LMKD

↓

Process Termination
```

The objective is to preserve user responsiveness while avoiding complete memory exhaustion.

---

# Android Memory States

Android classifies applications according to importance.

| State      | Priority |
| ---------- | -------- |
| Foreground | Highest  |
| Visible    | High     |
| Service    | Medium   |
| Background | Low      |
| Cached     | Lowest   |

Lower-priority processes are reclaimed first.

---

# Performance Considerations

Several factors influence memory performance.

Examples include:

- RAM capacity;
- ZRAM size;
- compression algorithm;
- application behavior;
- background services;
- graphics buffers.

Memory optimization therefore requires a system-wide perspective rather than focusing on a single parameter.

---

# HY300 Observations

During the HY300 Ultimate investigation, particular attention was paid to:

- total RAM capacity;
- ZRAM configuration;
- background service consumption;
- launcher memory usage;
- OEM application footprint;
- memory utilization during normal operation.

These observations established the project's performance baseline.

---

# Optimization Strategy

The project adopted a conservative optimization methodology.

```text
Measure

↓

Collect Baseline

↓

Identify Bottlenecks

↓

Modify One Variable

↓

Measure Again

↓

Validate
```

This approach avoids attributing performance improvements to unrelated changes.

---

# Common Misconceptions

Several common assumptions about Android memory are inaccurate.

| Myth                                         | Reality                                                                   |
| -------------------------------------------- | ------------------------------------------------------------------------- |
| More free RAM is always better               | Android intentionally uses RAM for caching.                               |
| ZRAM slows every device                      | Properly configured ZRAM usually improves responsiveness.                 |
| Killing background apps improves performance | Android already manages process lifecycles efficiently.                   |
| Swap is always beneficial                    | Excessive disk-based swap can reduce performance and increase flash wear. |

Understanding Android's memory model prevents unnecessary or counterproductive optimizations.

---

# Best Practices

When evaluating memory usage:

- Collect baseline measurements before making changes.
- Observe memory behavior over extended periods.
- Evaluate CPU usage together with RAM usage.
- Monitor ZRAM utilization.
- Avoid disabling Android memory management mechanisms without clear justification.
- Validate every optimization through measurable results.

---

# Summary

Android memory management combines RAM allocation, process prioritization, ZRAM compression, and intelligent process termination to maintain system responsiveness.

Rather than maximizing free memory, Android seeks to maximize useful memory while minimizing unnecessary application restarts.

Understanding these mechanisms is essential before optimizing firmware performance or removing OEM components.

---

# Next Chapter

Memory management alone does not determine Android's behavior.

The following chapter examines the **init process and Android services**, explaining how native daemons, system services, and proprietary OEM components are started during boot and how they interact throughout the lifetime of the operating system.

---

> [!IMPORTANT]
> Effective Android optimization begins with measurement, not modification. Memory statistics, ZRAM utilization, and process behavior should always be analyzed before changing system configuration. Optimizations supported by reproducible measurements are far more reliable than those based solely on intuition.