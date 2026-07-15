---
title: "Investigation Timeline"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Investigation Timeline

> *"Reverse engineering is rarely a straight path. It is a sequence of observations, hypotheses, experiments, failures, and discoveries that gradually reveal how a system truly works."*

---

# Introduction

By this stage of the project, the device had been identified, network connectivity established, Android Debug Bridge (ADB) access confirmed, and the available maintenance interfaces explored.

The next objective was to reconstruct the investigation itself.

Rather than presenting isolated technical findings, this chapter documents the chronological progression of the research.

Understanding **how** each discovery emerged is as important as understanding the discoveries themselves.

---

# Why Document the Timeline?

Engineering projects often document only successful outcomes.

However, the path leading to those outcomes contains valuable technical knowledge.

Recording the investigation timeline helps:

- explain why specific decisions were made;
- preserve experimental context;
- avoid repeating unsuccessful approaches;
- improve reproducibility;
- make the research easier to understand.

The timeline therefore serves as both technical documentation and a project journal.

---

# Phase 1 — Initial Discovery

The project began with a newly acquired Android projector whose internal architecture was almost entirely unknown.

Initial activities focused on observation rather than modification.

Objectives included:

- identifying the hardware;
- verifying Android availability;
- collecting firmware information;
- establishing safe access methods.

No firmware extraction was attempted during this phase.

---

# Phase 2 — Device Identification

The operating system and hardware platform were examined using standard Android tools.

Information collected included:

- Android version;
- build fingerprint;
- kernel version;
- system properties;
- storage layout;
- partition organization.

This information established the project's initial technical baseline.

---

# Phase 3 — Network Exploration

Attention then shifted to the network environment.

The investigation focused on:

- locating the projector;
- verifying connectivity;
- identifying exposed services;
- evaluating debugging interfaces.

This phase revealed that the device exposed significantly more information than initially expected.

---

# Phase 4 — ADB Discovery

One of the most important milestones occurred when Android Debug Bridge became accessible over the network.

This discovery transformed the investigation.

Instead of relying immediately on firmware extraction, the project could first observe the operating system while it was running.

ADB became the primary research interface for:

- system inspection;
- property collection;
- log analysis;
- filesystem exploration;
- process monitoring.

---

# Phase 5 — Recovery Investigation

Once reliable debugging access had been established, attention turned to the device's recovery capabilities.

The objectives were to determine:

- whether Recovery Mode existed;
- whether Fastboot was supported;
- which maintenance interfaces were available;
- how the device might be recovered after failed experiments.

Understanding these mechanisms reduced the risks associated with future firmware modifications.

---

# Phase 6 — Research Planning

At this point, the project transitioned from exploration to structured research.

The investigation objectives were refined.

Documentation standards were established.

Working hypotheses were defined.

Version control and reproducibility became central engineering principles.

This marked the beginning of a disciplined reverse engineering methodology.

---

# Evolution of the Investigation

The research naturally progressed through several stages.

```text
Acquire Device

↓

Observe

↓

Identify Hardware

↓

Explore Network

↓

Establish ADB Access

↓

Investigate Recovery

↓

Define Research Strategy

↓

Begin Reverse Engineering
```

Each stage depended on the successful completion of the previous one.

---

# Key Milestones

| Milestone                    | Outcome                         |
| ---------------------------- | ------------------------------- |
| Device acquired              | Investigation initiated         |
| Android identified           | Platform confirmed              |
| Network discovered           | Communication established       |
| ADB available                | Interactive debugging enabled   |
| Recovery analyzed            | Recovery options documented     |
| Research methodology defined | Structured investigation begins |

Each milestone reduced uncertainty and increased confidence in subsequent work.

---

# Lessons Learned

Several important lessons emerged during the early investigation.

## Observation Comes First

Attempting firmware modifications before understanding the device would likely have introduced unnecessary risk.

Observation consistently produced valuable information without compromising the system.

---

## Small Discoveries Matter

Many major breakthroughs originated from seemingly insignificant observations.

Examples include:

- unusual Android properties;
- unexpected network behavior;
- proprietary services;
- non-standard debugging configuration.

Careful documentation ensured that these details were not overlooked.

---

## Documentation Improves Engineering

Recording every step revealed relationships that might otherwise have been forgotten.

As the project grew, documentation became an integral engineering tool rather than a final deliverable.

---

# Decision Log

Throughout the investigation, several important decisions shaped the project's direction.

| Decision                           | Rationale                          |
| ---------------------------------- | ---------------------------------- |
| Preserve original firmware         | Maintain a reliable recovery point |
| Use ADB before firmware extraction | Minimize unnecessary risk          |
| Document every experiment          | Improve reproducibility            |
| Validate every hypothesis          | Avoid unsupported assumptions      |
| Maintain version control           | Preserve project history           |

These decisions remained valid throughout the remainder of the project.

---

# Challenges Encountered

The investigation was not linear.

Several obstacles influenced its progression.

Examples included:

- incomplete public documentation;
- proprietary firmware components;
- undocumented Android customizations;
- uncertainty regarding hardware revisions;
- non-standard implementation details.

Rather than treating these as setbacks, they became research opportunities.

---

# Research Timeline Overview

```text
Device Acquisition
        │
        ▼
Hardware Identification
        │
        ▼
Network Discovery
        │
        ▼
ADB Access
        │
        ▼
Recovery Investigation
        │
        ▼
Research Planning
        │
        ▼
Android Architecture Analysis
        │
        ▼
Reverse Engineering
        │
        ▼
ROM Reconstruction
        │
        ▼
Validation
        │
        ▼
Documentation
```

This timeline illustrates the logical progression of the project from initial observation to firmware development.

---

# Engineering Perspective

Looking back, one of the most significant aspects of the investigation was not a particular technical discovery.

It was the realization that a structured methodology consistently produced better results than isolated experimentation.

Every documented observation reduced uncertainty.

Every validated hypothesis strengthened the project's foundation.

Every unsuccessful experiment contributed to future understanding.

---

# Summary

The investigation timeline demonstrates that HY300 Ultimate evolved through incremental, evidence-based exploration.

Rather than rushing toward firmware modification, the project first established a comprehensive understanding of the target platform.

This disciplined approach laid the groundwork for the more advanced reverse engineering activities that follow in later volumes.

---

# Next Chapter

No engineering project progresses without obstacles.

The next chapter examines the first significant technical challenges encountered during the investigation, how they influenced the research strategy, and the lessons learned from overcoming them.

---

> [!TIP]
> Maintaining a chronological research log may seem time-consuming during active development, but it quickly becomes one of the most valuable engineering assets. It preserves context, explains design decisions, and makes complex investigations understandable long after the original experiments have been completed.