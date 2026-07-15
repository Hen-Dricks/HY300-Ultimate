---
title: "Integrating Projectivy Launcher"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Integrating Projectivy Launcher

> *"Replacing a launcher is not simply a visual change. On embedded Android devices, it means redefining the primary interface between the operating system, the user, and the underlying hardware."*

---

# Introduction

Following the evaluation of OEM applications, the next stage of the HY300 Ultimate project focused on replacing the manufacturer's launcher with an alternative better suited for projector use.

Among the available options, **Projectivy Launcher** was selected as the reference interface because it provides a streamlined experience specifically designed for Android-based projectors while remaining compatible with standard Android launcher mechanisms.

Rather than treating launcher replacement as a cosmetic modification, the project approached it as an architectural change requiring dependency analysis, validation, and careful integration.

---

# Objectives

This chapter aims to:

- explain the rationale behind using Projectivy Launcher;
- describe Android launcher selection;
- document integration methodology;
- analyze compatibility with projector features;
- establish validation procedures;
- preserve firmware stability.

The emphasis is on engineering methodology rather than installation instructions.

---

# Why Replace the OEM Launcher?

OEM launchers often include:

- manufacturer branding;
- bundled services;
- promotional content;
- vendor-specific shortcuts;
- tightly coupled interfaces.

For a custom firmware, engineering goals may instead prioritize:

- simplicity;
- responsiveness;
- customization;
- long-term maintainability;
- reduced software complexity.

A replacement launcher can better align with these objectives while preserving essential projector functionality.

---

# Android Launcher Architecture

Android selects a launcher through the HOME intent.

Simplified process:

```text
Boot Completed

↓

Package Manager

↓

Resolve HOME Intent

↓

Launcher

↓

User Interface
```

Only one launcher is active as the primary HOME application at any given time.

---

# Projectivy Launcher

Projectivy Launcher is designed specifically for Android TV and projector environments.

Typical characteristics include:

- clean interface;
- customizable layout;
- optimized navigation;
- support for remote controls;
- configurable shortcuts;
- lightweight operation.

Its design philosophy aligns well with embedded multimedia devices.

---

# Integration Strategy

Rather than immediately replacing the OEM launcher, the project followed a staged validation process.

```text
Preserve OEM Launcher

↓

Install Projectivy

↓

Validate Compatibility

↓

Evaluate Dependencies

↓

Select Default Launcher

↓

Long-Term Testing
```

This approach minimized the risk of rendering the system unusable.

---

# Dependency Analysis

The launcher itself is only one part of the user interface.

Dependencies may include:

- Android Framework;
- Activity Manager;
- Display Manager;
- Settings;
- projector services;
- autofocus controls;
- keystone interface.

Understanding these relationships is essential before making architectural changes.

---

# Simplified Architecture

```text
Android Framework

↓

HOME Intent

↓

Projectivy Launcher

↓

Android Services

↓

OEM Hardware Services

↓

Projection Hardware
```

The launcher provides the interface but continues to rely on Android's existing service infrastructure.

---

# User Experience Considerations

The replacement launcher should preserve access to critical projector functions.

Examples include:

- display settings;
- keystone adjustment;
- autofocus controls;
- HDMI input selection;
- wireless projection;
- application management.

Functional regression is unacceptable regardless of visual improvements.

---

# Runtime Validation

Useful diagnostic commands include:

Current HOME activity:

```bash
adb shell cmd package resolve-activity \
android.intent.action.MAIN
```

Installed launchers:

```bash
adb shell pm list packages
```

Current activity stack:

```bash
adb shell dumpsys activity
```

Runtime logs:

```bash
adb logcat
```

These observations help verify correct launcher integration.

---

# Compatibility Evaluation

Several functional areas should be validated.

| Feature             | Validation                |
| ------------------- | ------------------------- |
| Boot                | Launcher starts correctly |
| HOME button         | Expected behavior         |
| Remote navigation   | Responsive                |
| HDMI switching      | Functional                |
| Settings access     | Available                 |
| Projection controls | Accessible                |
| Performance         | Comparable to baseline    |

Validation should cover both software behavior and projector-specific functionality.

---

# Performance Considerations

Launcher performance may influence:

- boot time;
- memory consumption;
- application startup;
- interface responsiveness;
- navigation smoothness.

Objective measurements should always be compared against the original firmware baseline.

---

# Rollback Strategy

Every launcher evaluation should include a recovery path.

```text
OEM Launcher

↓

Projectivy Evaluation

↓

Validation

├── Successful → Adopt

└── Regression → Restore OEM Launcher
```

Maintaining a rollback option prevents unnecessary recovery procedures.

---

# Documentation

Each integration phase should be recorded.

| Item              | Description         |
| ----------------- | ------------------- |
| Launcher Version  | Recorded            |
| Firmware Revision | Recorded            |
| Validation Status | Complete            |
| Performance Notes | Recorded            |
| Final Decision    | Accepted / Reverted |

Consistent documentation improves reproducibility across firmware revisions.

---

# Reverse Engineering Workflow

The HY300 Ultimate project followed this methodology.

```text
Analyze OEM Launcher

↓

Install Alternative Launcher

↓

Validate Android Integration

↓

Test Projector Features

↓

Measure Performance

↓

Compare with Baseline

↓

Document Results
```

This workflow ensured that launcher replacement remained a controlled engineering activity.

---

# Engineering Observations

Several practical lessons emerged.

- The launcher is tightly integrated with Android's HOME mechanism.
- User interface changes should never compromise projector functionality.
- Compatibility testing is more important than visual appearance.
- Maintaining rollback capability significantly reduces engineering risk.
- Objective validation produces more reliable firmware than subjective preference.

---

# Common Challenges

Typical launcher integration challenges include:

- HOME intent conflicts;
- projector-specific shortcuts;
- OEM settings integration;
- remote-control navigation;
- display service dependencies;
- firmware-specific customizations.

These factors should be evaluated before adopting an alternative launcher.

---

# Best Practices

When integrating an alternative launcher:

- Preserve the original launcher.
- Validate every projector feature.
- Test multiple reboot cycles.
- Compare performance against the baseline.
- Document all observed differences.
- Maintain an immediate rollback path.

---

# Summary

Integrating Projectivy Launcher represents more than a cosmetic redesign.

Within the HY300 Ultimate project, launcher replacement was treated as a system-level engineering decision requiring dependency analysis, compatibility testing, performance evaluation, and careful validation.

By preserving the original firmware, documenting every observation, and testing projector-specific functionality throughout the process, the project ensured that the user interface could evolve without compromising system reliability.

---

# Next Chapter

With the launcher integration evaluated, the next chapter explores one of the most technically demanding stages of ROM reconstruction:

**rebuilding dynamic partitions with `lpmake`**.

Topics include:

- logical partition reconstruction;
- LP metadata generation;
- partition sizing;
- alignment requirements;
- rebuilding `super.img`;
- validation before flashing.

---

> [!IMPORTANT]
> A launcher replacement should always be evaluated as a system integration project rather than a visual customization. On embedded Android devices, the launcher serves as the primary interface to both Android services and projector-specific hardware, making compatibility and validation essential before adoption.