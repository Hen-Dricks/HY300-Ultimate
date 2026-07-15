---
title: "Annexe A — Commandes réseau"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "fr"
last_updated: "2026-07-14"
---

# Annexe A — Commandes réseau

> *« Observer le réseau est indispensable pour comprendre le comportement réel d'un firmware Android. »*

---

# Objectif

Cette annexe regroupe les principales commandes réseau utilisées au cours du projet HY300 Ultimate.

Les commandes sont classées par objectif afin de faciliter leur utilisation lors des phases d'analyse.

---

# Vérifier la connexion ADB

Lister les appareils.

```bash
adb devices
```

Connexion TCP.

```bash
adb connect <IP>:5555
```

Déconnexion.

```bash
adb disconnect
```

Redémarrer le serveur.

```bash
adb kill-server
adb start-server
```

---

# Obtenir les informations réseau

Adresse IP.

```bash
adb shell ip addr
```

Interfaces.

```bash
adb shell ip link
```

Route par défaut.

```bash
adb shell ip route
```

Nom d'hôte.

```bash
adb shell getprop net.hostname
```

DNS.

```bash
adb shell getprop | grep dns
```

---

# État du Wi-Fi

Informations générales.

```bash
adb shell dumpsys wifi
```

Configuration.

```bash
adb shell cmd wifi list-networks
```

SSID actuel.

```bash
adb shell dumpsys wifi | grep SSID
```

---

# Tester la connectivité

Ping.

```bash
adb shell ping 8.8.8.8
```

Ping DNS.

```bash
adb shell ping google.com
```

Traceroute (si disponible).

```bash
adb shell traceroute 8.8.8.8
```

---

# Observer les connexions

Sockets TCP.

```bash
adb shell ss -t
```

Sockets UDP.

```bash
adb shell ss -u
```

Toutes les connexions.

```bash
adb shell ss -tunap
```

Alternative.

```bash
adb shell netstat
```

---

# Résolution DNS

Configuration.

```bash
adb shell getprop | grep dns
```

Résolution.

```bash
adb shell nslookup google.com
```

(selon disponibilité)

---

# Examiner les propriétés réseau Android

Toutes les propriétés.

```bash
adb shell getprop
```

Uniquement le réseau.

```bash
adb shell getprop | grep net
```

Wi-Fi.

```bash
adb shell getprop | grep wifi
```

---

# Capturer les journaux

Journal complet.

```bash
adb logcat
```

Uniquement le réseau.

```bash
adb logcat | grep Wifi
```

DHCP.

```bash
adb logcat | grep DHCP
```

Bluetooth.

```bash
adb logcat | grep Bluetooth
```

---

# Observation des services

Services Binder.

```bash
adb shell service list
```

Service Wi-Fi.

```bash
adb shell dumpsys wifi
```

Connectivité.

```bash
adb shell dumpsys connectivity
```

---

# Vérifier les processus

Tous les processus.

```bash
adb shell ps -A
```

Uniquement le réseau.

```bash
adb shell ps -A | grep net
```

---

# Captures réseau

tcpdump (si présent).

```bash
adb shell tcpdump
```

Capture.

```bash
adb shell tcpdump -i any
```

---

# Tester les ports

Connexion.

```bash
adb shell nc
```

ou

```bash
adb shell telnet
```

(selon disponibilité)

---

# Transfert de fichiers

Vers Android.

```bash
adb push fichier /sdcard/
```

Depuis Android.

```bash
adb pull /sdcard/fichier
```

---

# Redémarrages utiles

Recovery.

```bash
adb reboot recovery
```

Bootloader.

```bash
adb reboot bootloader
```

Système.

```bash
adb reboot
```

---

# Outils Linux utilisés

Adresse IP.

```bash
ip addr
```

Route.

```bash
ip route
```

Interfaces.

```bash
ip link
```

Sockets.

```bash
ss -tunap
```

Résolution DNS.

```bash
dig
```

Traceroute.

```bash
traceroute
```

Capture.

```bash
tcpdump
```

---

# Tableau récapitulatif

| Objectif       | Commande principale     |
| -------------- | ----------------------- |
| Vérifier ADB   | `adb devices`           |
| Adresse IP     | `ip addr`               |
| Routes         | `ip route`              |
| Wi-Fi          | `dumpsys wifi`          |
| Réseau Android | `dumpsys connectivity`  |
| Services       | `service list`          |
| Journaux       | `logcat`                |
| Connexions     | `ss -tunap`             |
| Processus      | `ps -A`                 |
| Transfert      | `adb push` / `adb pull` |
| Redémarrage    | `adb reboot`            |

---

# Conseils

- Vérifier que l'appareil est bien détecté avec `adb devices` avant toute manipulation.
- Utiliser `dumpsys wifi` pour diagnostiquer les problèmes de connexion Wi-Fi.
- Préférer `ss` à `netstat` lorsqu'il est disponible.
- Capturer les journaux (`logcat`) pendant les tests afin de conserver une trace des événements réseau.
- Documenter les commandes réellement utilisées dans les rapports d'expérimentation pour garantir la reproductibilité.