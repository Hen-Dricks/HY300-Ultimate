---
title: "Annexe F — Glossaire"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "fr"
last_updated: "2026-07-14"
---

# Annexe F — Glossaire

> *« Comprendre le vocabulaire est la première étape pour comprendre un système. »*

---

# Objectif

Ce glossaire rassemble les principaux termes rencontrés tout au long de cette documentation.

Les définitions privilégient la clarté et le contexte d'utilisation dans le projet HY300 Ultimate.

---

# A

## A/B Partitions

Mécanisme Android permettant de conserver deux ensembles de partitions système afin de faciliter les mises à jour sans interrompre le fonctionnement de l'appareil.

---

## ADB (Android Debug Bridge)

Outil officiel d'Android permettant de communiquer avec un appareil pour le débogage, l'exécution de commandes, le transfert de fichiers et la collecte d'informations.

---

## APK

Package contenant une application Android.

---

## Android Verified Boot (AVB)

Mécanisme de vérification cryptographique garantissant l'intégrité des partitions critiques au démarrage.

---

# B

## Binder

Mécanisme de communication inter-processus (IPC) utilisé par Android pour permettre aux applications et services système d'échanger des informations.

---

## Boot Image

Image contenant le noyau Linux, le ramdisk et les informations nécessaires au démarrage d'Android.

---

## Bootloader

Programme exécuté immédiatement après la mise sous tension de l'appareil. Il prépare le démarrage du noyau Linux.

---

## Build

Version compilée d'un firmware ou d'un logiciel.

---

## Build.prop

Fichier contenant différentes propriétés système utilisées par Android au démarrage.

---

# C

## Chroot

Technique permettant d'exécuter un processus dans un environnement de fichiers isolé.

---

## CRC

Valeur de contrôle permettant de détecter certaines erreurs de transmission ou de stockage.

---

# D

## Daemon

Processus fonctionnant en arrière-plan pour assurer un service permanent.

---

## Docker

Plateforme de conteneurisation utilisée pour créer un environnement de développement reproductible.

---

## Dynamic Partitions

Architecture Android permettant de regrouper plusieurs partitions logiques dans une partition physique unique (`super.img`).

---

# E

## ext4

Système de fichiers Linux utilisé par la majorité des partitions Android.

---

## e2fsck

Outil permettant de vérifier et réparer une partition ext4.

---

# F

## Fastboot

Protocole de maintenance permettant, lorsqu'il est disponible, de communiquer avec le chargeur de démarrage pour certaines opérations de maintenance et de développement.

---

## Firmware

Ensemble des logiciels nécessaires au fonctionnement d'un appareil.

---

# G

## Git

Système de gestion de versions utilisé pour suivre les modifications du projet.

---

## GPU

Processeur spécialisé dans les calculs graphiques.

---

# H

## Hash

Empreinte numérique calculée à partir d'un fichier afin de vérifier son intégrité.

---

## HDMI

Interface numérique permettant la transmission de l'image et du son.

---

# I

## Image système

Fichier représentant le contenu complet d'une partition.

---

## Init

Premier processus lancé par Android après le démarrage du noyau.

---

# J

## Journal système

Ensemble des messages produits par Android ou Linux pendant leur fonctionnement.

---

# K

## Kernel

Noyau Linux utilisé par Android.

---

## Keystone

Correction géométrique permettant de compenser une projection inclinée.

---

# L

## Launcher

Application constituant l'écran d'accueil d'Android.

---

## Logcat

Outil Android permettant de consulter les journaux du système.

---

## Logical Partition

Partition virtuelle définie dans `super.img`.

---

## LP Metadata

Métadonnées décrivant les partitions dynamiques Android.

---

## lpmake

Outil Android permettant de reconstruire une partition `super.img`.

---

## lpunpack

Outil permettant d'extraire les partitions contenues dans `super.img`.

---

# M

## Mount

Opération consistant à rendre un système de fichiers accessible.

---

## microSD

Support de stockage amovible utilisé pour le transfert et l'archivage de données.

---

# O

## ODM

Partition contenant des composants spécifiques au fabricant de l'appareil.

---

## OTA (Over-The-Air)

Mise à jour distribuée via le réseau sans intervention physique.

---

# P

## Partition

Zone logique de stockage contenant une partie spécifique du système.

---

## Product

Partition regroupant certains composants logiciels propres au produit.

---

## Processus

Programme en cours d'exécution.

---

# R

## RAM

Mémoire vive utilisée par le système pour exécuter les applications.

---

## Recovery

Environnement minimal utilisé pour la maintenance, les mises à jour et la restauration.

---

## Reverse Engineering

Analyse d'un système afin d'en comprendre le fonctionnement sans disposer de sa documentation interne.

---

## Root

Compte disposant des privilèges les plus élevés sur un système Linux ou Android.

---

# S

## SELinux

Mécanisme de contrôle d'accès obligatoire renforçant la sécurité d'Android.

---

## SHA-256

Fonction de hachage cryptographique utilisée pour vérifier l'intégrité des fichiers.

---

## Sparse Image

Format d'image Android optimisé pour réduire la taille des partitions contenant de nombreuses zones vides.

---

## super.img

Partition physique contenant plusieurs partitions logiques Android.

---

## Swap

Zone de stockage utilisée comme extension de la mémoire vive.

---

## System

Partition contenant le cœur du système Android.

---

# T

## Tombstone

Rapport généré lors du plantage d'un processus natif Android.

---

## TXCZ

Nom associé à plusieurs composants propriétaires présents dans le firmware étudié.

---

# U

## USB Debugging

Fonction Android permettant l'utilisation d'ADB via une connexion USB.

---

# V

## vbmeta

Partition contenant les informations utilisées par Android Verified Boot.

---

## Vendor

Partition regroupant les composants matériels spécifiques au constructeur.

---

## Volume logique

Partition virtuelle créée à l'intérieur de `super.img`.

---

# W

## Working Copy

Copie de travail utilisée pour les expérimentations afin de préserver les fichiers d'origine.

---

# Z

## ZRAM

Bloc de mémoire compressée utilisé comme extension de la RAM pour améliorer la gestion de la mémoire sur certains appareils Android.

---

# Abréviations

| Abréviation | Signification                   |
| ----------- | ------------------------------- |
| ADB         | Android Debug Bridge            |
| APK         | Android Package                 |
| AVB         | Android Verified Boot           |
| CPU         | Central Processing Unit         |
| GPU         | Graphics Processing Unit        |
| IPC         | Inter-Process Communication     |
| LP          | Logical Partition               |
| OEM         | Original Equipment Manufacturer |
| OTA         | Over-The-Air                    |
| RAM         | Random Access Memory            |
| SHA         | Secure Hash Algorithm           |
| SoC         | System-on-Chip                  |
| USB         | Universal Serial Bus            |

---

# Pour aller plus loin

Les définitions de ce glossaire sont volontairement synthétiques.

Chaque terme est approfondi dans les chapitres correspondants des différents volumes de cette documentation.

---

> [!NOTE]
> Ce glossaire évoluera avec le projet. Les nouveaux termes introduits dans les prochaines versions de HY300 Ultimate seront ajoutés afin de conserver un vocabulaire cohérent et une documentation accessible à tous les lecteurs.