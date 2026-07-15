---
title: "Network Discovery"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "en"
last_updated: "2026-07-14"
---

# Network Discovery

> *"Before interacting with an embedded system, it is important to understand how it communicates with the outside world."*

---

# Introduction

After identifying the hardware platform and establishing the initial research hypotheses, the next step was to investigate the projector's network behavior.

Rather than immediately attempting firmware extraction or modification, the objective was to observe how the device communicated with its environment.

Network discovery serves several purposes:

- locating debugging interfaces;
- identifying available services;
- understanding communication protocols;
- detecting update mechanisms;
- establishing reliable access for future analysis.

This phase remained entirely observational.

No firmware components were modified.

---

# Objectives

The network investigation pursued several goals.

- Identify the device on the local network.
- Determine whether Android Debug Bridge (ADB) was available.
- Detect open TCP and UDP ports.
- Observe network services.
- Identify OTA communication.
- Verify network stability.
- Establish a reliable development workflow.

---

# Initial Network Topology

The investigation was performed within an isolated local network.

```text
                Local Network

        +-------------------------+
        |        Router           |
        +-----------+-------------+
                    |
     -------------------------------
     |                             |
Development Workstation      HY300 Projector
(macOS / Linux)            (Android Device)
```

The isolated environment ensured that experiments would not interfere with unrelated systems while allowing unrestricted observation of the projector's network activity.

---

# Obtaining the IP Address

The first task consisted of identifying the projector on the network.

Possible methods included:

- router administration interface;
- Android Wi-Fi settings;
- network scanning tools;
- DHCP lease tables.

Once identified, the IP address became the primary endpoint for subsequent analysis.

---

# Verifying Connectivity

Basic connectivity was verified before attempting more advanced operations.

Ping test:

```bash
ping <PROJECTOR_IP>
```

Successful responses confirmed that the device was reachable over the local network.

---

# Network Fingerprinting

Basic information was collected using standard networking tools.

Examples include:

```bash
arp -a
```

```bash
ping <PROJECTOR_IP>
```

```bash
traceroute <PROJECTOR_IP>
```

These commands helped confirm:

- network reachability;
- latency;
- address resolution;
- routing behavior.

---

# Port Discovery

The next objective was identifying exposed services.

Typical scanning tools include:

```bash
nmap <PROJECTOR_IP>
```

or

```bash
nmap -sV <PROJECTOR_IP>
```

The investigation focused on identifying services commonly associated with Android devices, including:

- ADB
- HTTP
- HTTPS
- SSH
- FTP
- proprietary services

Every discovered service was documented before further analysis.

---

# Android Debug Bridge

One of the primary objectives was determining whether ADB over TCP/IP had already been enabled.

Typical connection attempt:

```bash
adb connect <PROJECTOR_IP>:5555
```

If successful:

```bash
adb devices
```

would display the projector as an available debugging target.

At this stage, the availability of ADB represented a major milestone because it eliminated the need for invasive hardware access during the early phases of the investigation.

---

# Service Enumeration

Beyond ADB, the investigation searched for additional services.

Typical categories included:

| Service     | Purpose                             |
| ----------- | ----------------------------------- |
| HTTP        | Web interface                       |
| HTTPS       | Secure web services                 |
| ADB         | Android debugging                   |
| RTSP        | Media streaming                     |
| Proprietary | Manufacturer-specific communication |

The presence of unexpected services often provides valuable insight into OEM firmware architecture.

---

# Observing Network Traffic

Passive observation was preferred over active interaction whenever possible.

Typical tools include:

```bash
tcpdump
```

```bash
Wireshark
```

Network captures may reveal:

- DNS requests;
- NTP synchronization;
- OTA update checks;
- telemetry;
- cloud communication;
- local service discovery.

These observations become increasingly valuable during later firmware analysis.

---

# OTA Discovery

One important objective was determining whether the device contacted remote update servers.

Potential indicators include:

- periodic HTTPS requests;
- update domains;
- version checks;
- download endpoints.

The goal at this stage was only to observe the existence of update mechanisms—not to interfere with them.

---

# Local Network Behavior

Several aspects of network behavior were documented.

Examples include:

- DHCP lease acquisition;
- hostname announcements;
- DNS resolution;
- multicast traffic;
- broadcast messages;
- service discovery protocols.

Even seemingly minor observations can later help explain firmware behavior.

---

# Security Considerations

The network investigation respected several safety principles.

- No unauthorized access attempts.
- No exploitation of discovered services.
- No denial-of-service testing.
- No modification of network traffic.
- No interception of third-party communications.

The purpose of this phase was documentation rather than intrusion.

---

# Findings

At the conclusion of the network discovery phase, the following information had been collected.

| Category              | Status       |
| --------------------- | ------------ |
| Device reachable      | Verified     |
| IP address identified | Verified     |
| Local connectivity    | Verified     |
| Open services         | Documented   |
| Debug interface       | Investigated |
| OTA communication     | Observed     |
| Network baseline      | Established  |

This baseline would support every subsequent stage of the project.

---

# Methodology

The investigation followed a structured sequence.

```text
Connect Device

↓

Identify IP Address

↓

Verify Connectivity

↓

Scan Services

↓

Test ADB

↓

Observe Traffic

↓

Document Results
```

Each step built upon the previous one while minimizing unnecessary interaction with the device.

---

# Best Practices

During network discovery:

- Perform experiments on an isolated network whenever possible.
- Record IP addresses and scan results.
- Preserve packet captures.
- Repeat scans after firmware updates.
- Document every discovered service.
- Differentiate confirmed observations from assumptions.

A well-documented network baseline simplifies every later phase of reverse engineering.

---

# Summary

Network discovery established the communication baseline of the HY300 projector.

The device was successfully identified on the local network, its connectivity verified, and its exposed services documented.

Most importantly, this phase determined the available debugging interfaces and provided a safe foundation for all subsequent firmware analysis.

---

# Next Chapter

With the network environment understood, the investigation turns to one of the most important discoveries of the project:

the availability of **Android Debug Bridge (ADB) on a non-standard TCP port**.

This unexpected behavior significantly influenced the entire reverse engineering workflow and opened new possibilities for firmware analysis.

---

> [!NOTE]
> Network discovery is not merely a preliminary step—it often reveals hidden capabilities, undocumented services, and debugging interfaces that fundamentally shape the direction of an embedded systems investigation.