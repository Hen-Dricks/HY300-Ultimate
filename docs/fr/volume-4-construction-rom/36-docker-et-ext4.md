---
title: "Environnement de travail : Docker, Linux et systèmes de fichiers Android"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 36 — Environnement de travail

> *« Modifier Android ne consiste pas uniquement à éditer des fichiers. Il faut d'abord reconstruire un environnement capable de comprendre les formats utilisés par le firmware. »*

---

# Introduction

Une fois les partitions sauvegardées, une nouvelle difficulté apparaît.

Les partitions Android ne peuvent généralement pas être modifiées directement depuis Windows ou macOS.

Leur contenu repose principalement sur des systèmes de fichiers Linux (ext4) ainsi que sur des mécanismes spécifiques à Android comme les images dynamiques (`super.img`).

Avant toute modification, il est donc nécessaire de construire un environnement de travail adapté.

Ce chapitre explique les choix retenus pour le projet HY300 Ultimate.

---

# Pourquoi ne pas modifier directement les fichiers ?

Le firmware Android est constitué de plusieurs couches.

Par exemple :

```
super.img

↓

Partition logique

↓

Image ext4

↓

Répertoires Linux

↓

Applications

↓

Bibliothèques

↓

Configuration Android
```

Modifier directement `super.img` avec un éditeur hexadécimal serait pratiquement impossible.

Il faut d'abord reconstruire chaque couche.

---

# Pourquoi Docker ?

Au début du projet, plusieurs possibilités ont été étudiées.

## Linux natif

Avantages :

- performances maximales
- accès direct au noyau

Inconvénients :

- dépend du système de l'utilisateur
- nombreuses dépendances

---

## Machine virtuelle

Avantages :

- environnement isolé

Inconvénients :

- consommation mémoire importante
- performances parfois limitées

---

## Docker

Docker a finalement été retenu.

Pourquoi ?

Parce qu'il permet :

- un environnement reproductible ;
- une installation rapide ;
- un partage simple de la configuration ;
- une compatibilité avec macOS, Linux et Windows.

Tous les lecteurs du projet peuvent ainsi reconstruire exactement le même environnement.

---

# Notre environnement

Le projet HY300 Ultimate repose sur un conteneur Docker contenant notamment :

- Python ;
- Android SDK Platform Tools ;
- e2fsprogs ;
- lpunpack ;
- lpmake ;
- simg2img ;
- img2simg ;
- debugfs ;
- resize2fs ;
- make_ext4fs (selon les besoins).

Cette liste évoluera au fil du projet.

---

# Pourquoi Linux ?

Les partitions Android utilisent principalement :

```
ext4
```

Or :

macOS ne sait pas monter ext4 en écriture de manière native.

Windows non plus.

Linux reste donc la plateforme de référence.

---

# Comprendre ext4

Ext4 est le système de fichiers utilisé par la majorité des partitions Android.

Il contient notamment :

- superbloc ;
- inodes ;
- bitmap des blocs ;
- journal (journalisation) ;
- répertoires ;
- fichiers.

Comprendre cette structure est essentiel pour modifier une image sans la corrompre.

---

# Sparse images

Android utilise fréquemment un format particulier :

```
Sparse Image
```

Une sparse image n'est pas une image disque classique.

Elle remplace les longues séquences de blocs vides par une représentation compacte.

Conséquences :

- fichiers plus petits ;
- téléchargement plus rapide ;
- impossible à monter directement.

Avant toute modification :

```
Sparse

↓

simg2img

↓

Image ext4
```

Après modification :

```
Image ext4

↓

img2simg

↓

Sparse
```

---

# Pourquoi cette conversion ?

Les outils Linux travaillent généralement sur des images ext4 classiques.

Les images sparse sont principalement destinées :

- au flash ;
- aux OTA ;
- aux constructeurs.

Le développeur travaille donc sur une image convertie.

---

# Les outils utilisés

Au cours du projet, plusieurs outils sont utilisés.

| Outil     | Rôle                                     |
| --------- | ---------------------------------------- |
| simg2img  | conversion sparse → ext4                 |
| img2simg  | conversion ext4 → sparse                 |
| lpunpack  | extraction de `super.img`                |
| lpmake    | reconstruction des partitions dynamiques |
| debugfs   | inspection d'une image ext4              |
| resize2fs | redimensionnement                        |
| e2fsck    | vérification d'intégrité                 |

Chaque outil fera l'objet d'un chapitre spécifique.

---

# Les erreurs classiques

Plusieurs erreurs peuvent apparaître.

## Monter une sparse image

Impossible.

Il faut d'abord :

```
simg2img
```

---

## Modifier une image montée

Une interruption peut provoquer une corruption.

Toujours démonter proprement.

---

## Oublier e2fsck

Après certaines modifications,

il est conseillé de vérifier :

```
e2fsck
```

avant de reconstruire le firmware.

---

## Taille de partition

Une image modifiée peut devenir plus volumineuse.

Elle devra toujours rester compatible avec la taille de la partition logique.

---

# Notre organisation

Toutes les opérations sont réalisées dans un répertoire de travail dédié.

```
workspace/

├── original/
├── extracted/
├── mounted/
├── rebuilt/
├── docker/
└── scripts/
```

Cette organisation évite toute confusion entre les images originales et les images modifiées.

---

# Journal de développement

**Date :**

2026-07-14

**Objectif :**

Construire un environnement de travail reproductible.

**Résultat :**

✓ Docker retenu.

✓ Outils Linux installés.

✓ Environnement documenté.

✓ Structure du projet définie.

**Décision :**

Toutes les modifications du firmware seront réalisées exclusivement dans cet environnement afin de garantir la reproductibilité des résultats.

---

# Conclusion

Avant de modifier un firmware Android, il est indispensable de disposer d'un environnement capable de comprendre les formats utilisés par le système.

Docker et les outils Linux constituent une solution robuste, portable et reproductible.

Cette étape pose les bases techniques nécessaires aux chapitres suivants, qui aborderont l'extraction des partitions logiques et la reconstruction complète de `super.img`.

---

> [!TIP]
> L'environnement de travail est aussi important que les outils de reverse engineering eux-mêmes. Une configuration reproductible simplifie le débogage, facilite les contributions externes et garantit que les résultats pourront être reproduits plusieurs mois ou années plus tard.

---

# Chapitre suivant

➡️ **37 – Décomposition de `super.img` : analyse de la partition dynamique avec `lpunpack`**