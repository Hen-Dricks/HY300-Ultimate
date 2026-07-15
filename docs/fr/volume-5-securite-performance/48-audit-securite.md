---
title: "Audit de sécurité du firmware HY300"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 48 — Audit de sécurité du firmware HY300

> *« Un firmware propriétaire n'est pas nécessairement dangereux. En revanche, un firmware opaque mérite toujours une analyse approfondie. »*

---

# Résumé exécutif

L'objectif de ce chapitre est d'établir une photographie objective de la sécurité du firmware d'origine installé sur le projecteur HY300.

Contrairement à une approche orientée "pentest", notre démarche consiste à :

- inventorier les composants exposés ;
- comprendre leur rôle ;
- identifier les surfaces d'attaque ;
- distinguer les risques théoriques des problèmes réellement observés.

À ce stade du projet, **aucune vulnérabilité exploitable n'est affirmée sans preuve expérimentale**.

---

# Pourquoi réaliser un audit ?

Le firmware d'un appareil connecté contrôle :

- le démarrage ;
- le réseau ;
- les mises à jour ;
- les applications système ;
- les accès matériels.

Une erreur de conception dans l'un de ces composants peut avoir des conséquences importantes.

Notre objectif est donc de comprendre le niveau de sécurité réel du système.

---

# Méthodologie

L'audit repose sur plusieurs axes complémentaires.

## Analyse statique

Étude des partitions :

- `system`
- `vendor`
- `product`
- `boot`
- `vbmeta`

Analyse :

- APK
- bibliothèques natives
- scripts `init`
- fichiers de configuration

---

## Analyse dynamique

Observation du système en fonctionnement.

Outils utilisés :

```bash
adb

logcat

dmesg

ps

getprop

dumpsys
```

L'objectif est de comprendre le comportement réel du firmware.

---

## Analyse réseau

Observation :

- des ports ouverts ;
- des services actifs ;
- des communications sortantes ;
- des mécanismes OTA.

Les captures réseau et les journaux seront documentés dans les chapitres dédiés.

---

# Surface d'attaque

Le firmware expose plusieurs catégories de composants.

## Interfaces physiques

- USB
- HDMI
- alimentation
- lecteur microSD

---

## Interfaces logiques

- Wi-Fi
- Bluetooth
- ADB
- services Android

---

## Applications système

Chaque application système constitue un point d'entrée potentiel.

L'analyse porte notamment sur :

- permissions ;
- composants exportés ;
- services ;
- receivers.

---

## Services propriétaires

Le firmware comporte plusieurs services OEM.

Ils feront chacun l'objet d'une analyse spécifique afin de déterminer :

- leur rôle ;
- leurs privilèges ;
- leur exposition ;
- leurs interactions avec Android.

---

# Éléments étudiés

Au cours de cette étude, nous avons notamment documenté :

- le démon Daemon12138 ;
- les applications TXCZ ;
- les mécanismes OTA ;
- les bibliothèques natives OEM ;
- les scripts `init`.

Ces composants représentent les principales zones d'intérêt du firmware.

---

# Android Verified Boot

Une attention particulière est portée au mécanisme AVB.

Les questions suivantes guideront l'analyse.

- Le firmware utilise-t-il Android Verified Boot ?
- Les partitions sont-elles protégées ?
- Les signatures sont-elles cohérentes ?
- Quel est le rôle de `vbmeta` ?

Ces éléments seront approfondis dans les chapitres suivants.

---

# SELinux

SELinux constitue l'un des principaux mécanismes de protection d'Android.

L'audit portera notamment sur :

- le mode d'exécution ;
- les politiques chargées ;
- les éventuels refus enregistrés dans les journaux.

Aucune conclusion ne sera tirée sans analyse des données disponibles.

---

# Communications réseau

L'étude du firmware a montré que plusieurs composants sont capables d'établir des communications réseau.

L'objectif est de déterminer :

- quelles connexions sont initiées ;
- dans quelles circonstances ;
- avec quels services distants.

La simple existence d'une communication réseau ne constitue pas un comportement malveillant.

Elle doit être replacée dans son contexte fonctionnel.

---

# Critères d'évaluation

Chaque observation sera classée selon quatre niveaux.

| Niveau                  | Signification                            |
| ----------------------- | ---------------------------------------- |
| Observation             | Comportement constaté                    |
| Risque potentiel        | Peut augmenter la surface d'attaque      |
| Faiblesse confirmée     | Comportement objectivement problématique |
| Vulnérabilité démontrée | Exploitation reproductible documentée    |

Cette classification évite les conclusions hâtives.

---

# Ce que nous avons observé

Au moment de cette rédaction, plusieurs constats peuvent être établis.

## Confirmé

- présence de composants OEM spécifiques ;
- services propriétaires intégrés ;
- mécanisme OTA constructeur ;
- accès ADB disponible dans le cadre de nos tests.

## À approfondir

- exposition exacte des services ;
- interactions réseau ;
- privilèges accordés aux composants OEM ;
- mécanismes de mise à jour.

---

# Limites

Cet audit ne prétend pas être exhaustif.

Certaines fonctionnalités peuvent dépendre :

- d'une connexion Internet ;
- d'un serveur constructeur ;
- d'un état particulier de l'appareil ;
- d'une version spécifique du firmware.

Les conclusions pourront donc évoluer avec de nouvelles observations.

---

# Recommandations

À ce stade, plusieurs bonnes pratiques peuvent être retenues.

- Conserver les sauvegardes des partitions d'origine.
- Vérifier l'intégrité des images avant toute modification.
- Documenter chaque changement.
- Isoler les expérimentations sur des copies du firmware.
- Ne qualifier une vulnérabilité qu'après reproduction.

---

# Journal d'audit

**Objectif**

Évaluer le niveau de sécurité du firmware OEM.

**Méthodologie**

Analyse statique, dynamique et réseau.

**Résultat**

L'inventaire des composants est établi.

L'analyse détaillée des mécanismes de sécurité se poursuit dans les chapitres suivants.

---

# Conclusion

Le firmware du HY300 présente une architecture comparable à celle de nombreux appareils Android embarqués enrichis par des composants propriétaires.

L'audit réalisé dans ce chapitre constitue une base méthodologique.

Il permet d'identifier les éléments qui méritent une analyse approfondie tout en évitant les conclusions non étayées.

Le but du projet n'est pas de démontrer qu'un composant est dangereux, mais de comprendre précisément son rôle et son niveau d'exposition.

---

> [!IMPORTANT]
> Dans l'ensemble de cette documentation, les termes **"risque"**, **"faiblesse"** et **"vulnérabilité"** ne sont jamais utilisés comme des synonymes. Une vulnérabilité n'est considérée comme confirmée que lorsqu'elle peut être reproduite et documentée de manière fiable.

---

# Chapitre suivant

➡️ **49 – Recovery, Fastboot et interfaces USB : analyse des mécanismes de maintenance et de récupération**