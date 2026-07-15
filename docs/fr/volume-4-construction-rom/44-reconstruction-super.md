---
title: "Reconstruction finale de super.img"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 44 — Reconstruction finale de super.img

> *« Reconstruire une partition dynamique ne consiste pas simplement à assembler plusieurs images. Il s'agit de recréer une structure logique complète que le chargeur de démarrage, le noyau Linux et Android devront tous interpréter de manière identique. »*

---

# Introduction

Après avoir :

- extrait les partitions dynamiques ;
- analysé leur contenu ;
- modifié les composants souhaités ;
- validé individuellement chaque image ;

vient enfin l'étape la plus importante du projet :

**la reconstruction complète de `super.img`.**

Cette opération marque la transition entre une simple collection de partitions modifiées et une image système exploitable par le projecteur.

---

# Objectifs

La reconstruction doit produire une image :

- cohérente ;
- amorçable ;
- conforme au layout LP d'origine ;
- compatible avec Android Dynamic Partitions ;
- reproductible.

---

# Architecture

Le processus complet est le suivant.

```text
Firmware OEM

↓

super.img

↓

lpunpack

↓

system.img
vendor.img
product.img
odm.img

↓

Modifications

↓

Validation individuelle

↓

lpmake

↓

super-hy300-ultimate.img

↓

Validation

↓

Flash

↓

Tests matériels
```

Chaque étape est vérifiée avant de passer à la suivante.

---

# Préparation

Avant de lancer `lpmake`, plusieurs vérifications sont systématiquement réalisées.

## Vérification des systèmes de fichiers

```bash
e2fsck -f system.img
e2fsck -f vendor.img
e2fsck -f product.img
e2fsck -f odm.img
```

Aucune image ne doit présenter d'erreur.

---

## Vérification des tailles

Chaque partition est comparée :

- à sa taille logique ;
- à la capacité de son groupe LP ;
- à la taille totale de `super`.

Ces contrôles évitent les erreurs de reconstruction.

---

## Vérification des empreintes

Toutes les partitions modifiées reçoivent une nouvelle empreinte SHA-256.

Ces empreintes sont archivées afin de garantir la traçabilité des modifications.

---

# Reconstruction

La reconstruction est réalisée avec :

```text
lpmake
```

Cet outil :

- crée les métadonnées LP ;
- déclare les groupes ;
- associe chaque partition logique ;
- génère une nouvelle image `super.img`.

La ligne de commande exacte utilisée dans le projet sera documentée ici lorsque la version finale sera stabilisée.

---

# Les paramètres importants

Lors de la reconstruction, plusieurs paramètres sont critiques.

## Taille totale

Elle doit correspondre exactement à la partition physique.

---

## Métadonnées

Les tailles et versions des métadonnées LP doivent rester cohérentes.

---

## Groupes

Chaque partition logique appartient à un groupe.

Le dépassement de la capacité d'un groupe entraîne un échec de la reconstruction.

---

## Alignement

Les offsets doivent respecter les contraintes imposées par Android.

---

# Contrôles immédiats

Une fois `super.img` générée, plusieurs vérifications sont effectuées.

## Taille

La taille finale est comparée à celle de la partition `super` d'origine.

---

## Empreinte

Une nouvelle empreinte SHA-256 est calculée.

---

## Ré-extraction

La première validation consiste à exécuter de nouveau :

```bash
lpunpack super-hy300-ultimate.img
```

Toutes les partitions doivent pouvoir être extraites sans erreur.

---

## Vérification des images

Les partitions extraites sont comparées aux images ayant servi à la reconstruction.

Aucune différence inattendue ne doit apparaître.

---

# Comparaison avec l'image d'origine

Deux images sont désormais disponibles.

```
super-original.img

↓

Firmware constructeur
```

```
super-hy300-ultimate.img

↓

Firmware modifié
```

L'objectif est de documenter précisément les différences introduites.

---

# Contrôle des modifications

Les différences doivent être limitées aux éléments explicitement modifiés.

Par exemple :

- Projectivy Launcher ajouté ;
- applications OEM supprimées ;
- fichiers de configuration ajustés.

Toute différence non expliquée fera l'objet d'une investigation.

---

# Validation de la structure

Nous vérifions que :

- les partitions logiques sont présentes ;
- leurs tailles sont correctes ;
- les groupes sont cohérents ;
- les métadonnées LP sont valides.

Cette étape garantit que l'image reconstruite respecte l'architecture Android.

---

# Préparation au flash

Avant toute écriture sur le projecteur, les éléments suivants sont archivés.

```
release/

├── super-hy300-ultimate.img
├── SHA256SUMS
├── build-report.md
├── layout.json
└── reconstruction.log
```

Cette archive constitue la référence officielle de la build.

---

# Journal de développement

**Date**

2026-07-14

**Objectif**

Reconstruire une image `super.img` intégrant les premières modifications de HY300 Ultimate.

**Résultat**

En cours de validation.

Les commandes définitives, les paramètres `lpmake` et les journaux de reconstruction seront ajoutés une fois la build finale stabilisée.

---

# Enseignements

La reconstruction de `super.img` est bien plus qu'une opération d'assemblage.

Elle nécessite une compréhension approfondie :

- des partitions dynamiques ;
- des métadonnées LP ;
- des groupes ;
- des contraintes d'alignement ;
- des systèmes de fichiers.

Cette étape constitue le véritable point de convergence de tout le travail réalisé depuis le début du projet.

---

# Conclusion

La reconstruction finale de `super.img` représente l'aboutissement de la chaîne de développement de HY300 Ultimate.

Une fois cette image générée et validée, le projet dispose d'un firmware complet, prêt à être testé sur le matériel réel.

Les chapitres suivants seront consacrés à ces validations et à la préparation des premières versions publiques.

---

> [!IMPORTANT]
> Une image `super.img` correctement reconstruite n'est pas nécessairement une image fonctionnelle. La reconstruction valide la cohérence de la structure ; seules les validations sur le matériel permettront de confirmer que l'ensemble des composants fonctionne comme attendu.

---

# Chapitre suivant

➡️ **45 – Validation bit à bit : comparaison du firmware OEM et de HY300 Ultimate**