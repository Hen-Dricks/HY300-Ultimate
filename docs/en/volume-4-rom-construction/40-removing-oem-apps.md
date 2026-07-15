---
title: "Evaluating OEM Applications for Removal"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Evaluating OEM Applications for Removal

> *"A custom ROM should remove unnecessary complexity—not essential functionality. Every OEM application deserves to be evaluated according to its role, dependencies, and contribution to the system."*

---

# Introduction

Following the evaluation methodology established for daemon12138, the next stage of firmware reconstruction focuses on **OEM applications**.

Commercial Android firmware often contains numerous vendor applications developed specifically for the target hardware.

Some provide indispensable functionality, while others exist solely for manufacturing, diagnostics, regional customization, or optional services.

The objective of the HY300 Ultimate project was **not** to remove OEM software indiscriminately, but to determine—through observation and testing—which applications were necessary for the desired firmware configuration.

This chapter presents the engineering methodology used to evaluate those applications.

---

# Objectives

This chapter aims to:

- classify OEM applications;
- evaluate their necessity;
- document dependency analysis;
- define validation criteria;
- establish a reproducible decision process;
- prepare the firmware for customization.

No application removal procedure is described in this chapter.

---

# Why Evaluate OEM Applications?

OEM firmware evolves over time.

Applications may remain installed even after:

- hardware revisions;
- feature deprecation;
- manufacturing changes;
- software redesign;
- regional customization.

Consequently, the presence of an application does not automatically imply that it remains essential.

Only systematic analysis can determine its actual role.

---

# Classification Strategy

Applications were grouped according to their observed purpose.

| Category              | Typical Examples               |
| --------------------- | ------------------------------ |
| Core Android          | Framework applications         |
| Projector Features    | Keystone, Autofocus            |
| User Interface        | Launcher                       |
| Connectivity          | QuickShare, USBDisplay         |
| Maintenance           | OTA services                   |
| Factory Utilities     | Test applications              |
| Optional Applications | Demonstrations, samples        |
| Unknown Components    | Further investigation required |

Classification simplifies later engineering decisions.

---

# Engineering Philosophy

The project followed a conservative workflow.

```text
Identify

↓

Classify

↓

Observe

↓

Document

↓

Validate

↓

Decide
```

Applications were never categorized solely by package name.

---

# Dependency Mapping

Each application was evaluated within the context of the entire firmware.

```text
Application

↓

Native Libraries

↓

OEM Services

↓

Android Framework

↓

Hardware
```

Removing one application without understanding these relationships could affect apparently unrelated features.

---

# Evaluation Criteria

Each application was examined using several questions.

- Does it launch automatically?
- Does another application depend on it?
- Does it communicate with native libraries?
- Does it expose projector functionality?
- Does it access privileged Android APIs?
- Is it used during normal operation?
- Can equivalent functionality be provided elsewhere?

Answers were derived from observation rather than inference.

---

# Categories of Applications

The investigation identified several recurring categories.

## Essential Applications

Typically responsible for:

- system startup;
- projector control;
- hardware integration;
- user interface.

These generally require careful evaluation before modification.

---

## Feature Applications

Examples include:

- wireless projection;
- media sharing;
- firmware updates.

Whether these remain necessary depends on the intended ROM design.

---

## Factory Utilities

Usually intended for:

- diagnostics;
- production testing;
- calibration;
- engineering validation.

These applications may no longer be required after manufacturing, but their removal must still be validated.

---

## Demonstration Software

Some firmware images include applications intended for:

- demonstrations;
- marketing;
- regional customization;
- bundled services.

These are often the least critical category but should still be evaluated systematically.

---

# Runtime Observation

Useful diagnostic commands include:

List installed packages:

```bash
adb shell pm list packages
```

Inspect running processes:

```bash
adb shell ps -A
```

Collect runtime logs:

```bash
adb logcat
```

Display active services:

```bash
adb shell dumpsys activity services
```

These observations help distinguish active system components from inactive applications.

---

# Baseline Comparison

Every evaluation compared two states.

```text
Reference Firmware

↓

Observed Behavior

↓

Engineering Evaluation

↓

Customized Firmware

↓

Comparison
```

The objective was to identify measurable differences rather than relying on subjective impressions.

---

# Validation Areas

After evaluating an application's role, several aspects should be verified.

| Area        | Validation Goal        |
| ----------- | ---------------------- |
| Boot        | Successful startup     |
| Launcher    | Stable operation       |
| Projection  | Correct image output   |
| Autofocus   | Normal behavior        |
| Keystone    | Functional calibration |
| HDMI        | Proper input detection |
| Network     | Expected connectivity  |
| Performance | Comparable baseline    |

A modification should only be accepted if the intended functionality remains consistent.

---

# Documentation

Each evaluation should be recorded.

| Item              | Description                    |
| ----------------- | ------------------------------ |
| Package Name      | Documented                     |
| Category          | Assigned                       |
| Dependencies      | Recorded                       |
| Validation Status | Complete                       |
| Decision          | Retain / Exclude / Investigate |

Maintaining structured records simplifies future firmware revisions.

---

# Reverse Engineering Workflow

The HY300 Ultimate project followed this methodology.

```text
Identify Application

↓

Classify Purpose

↓

Analyze Dependencies

↓

Observe Runtime

↓

Validate System

↓

Compare with Baseline

↓

Document Decision
```

This workflow remained consistent across all OEM software evaluations.

---

# Engineering Observations

Several important lessons emerged.

- Many applications interact with native services.
- Package names do not always reflect functionality.
- Runtime behavior is more informative than installation location.
- Documentation significantly reduces engineering uncertainty.
- Incremental evaluation simplifies troubleshooting.

---

# Common Challenges

Typical challenges include:

- undocumented package names;
- shared native libraries;
- hidden background services;
- regional firmware variations;
- proprietary APIs;
- indirect dependencies.

These reinforce the importance of careful observation.

---

# Best Practices

When evaluating OEM applications:

- Preserve original APKs.
- Classify before modifying.
- Evaluate one application category at a time.
- Compare against a documented baseline.
- Record all observations.
- Maintain complete rollback capability.

---

# Summary

The evaluation of OEM applications is a critical step in developing a reliable custom ROM.

Rather than removing software based on assumptions, the HY300 Ultimate project applied a structured methodology based on classification, dependency analysis, runtime observation, and validation.

This process ensured that firmware simplification remained compatible with the projector's essential functionality while preserving reproducibility throughout the engineering workflow.

---

# Next Chapter

With the OEM software landscape fully evaluated, the next chapter explores the integration of an alternative launcher:

**Projectivy Launcher**.

Topics include:

- launcher replacement strategy;
- Android HOME intent;
- compatibility considerations;
- user interface customization;
- dependency analysis;
- validation methodology.

---

> [!IMPORTANT]
> An OEM application should never be considered unnecessary simply because it appears inactive or unfamiliar. Reliable firmware engineering requires understanding how software components interact with the operating system and hardware before deciding whether they belong in a customized ROM.