---
title: "Les partitions dynamiques"
author: "HY300 Ultimate Research"
version: "1.0"
language: "fr"
status: "Draft"
last_updated: "2026-07-14"
---

# Chapitre 13 — Les partitions dynamiques

> *« Android 10 n'a pas seulement changé le partitionnement. Il a complètement changé la manière dont un firmware est construit. »*

---

# Objectifs

À la fin de ce chapitre le lecteur comprendra :

- pourquoi Google a créé les Dynamic Partitions ;
- comment fonctionne `super.img` ;
- ce qu'est LPMetadata ;
- comment Android retrouve les partitions logiques ;
- pourquoi il ne faut jamais modifier `super.img` directement ;
- comment reconstruire une image sans casser le firmware.

---

# Introduction

Pendant des années, Android utilisait des partitions physiques fixes.

Chaque image correspondait exactement à une partition.

```
boot.img

system.img

vendor.img

recovery.img
```

Cette organisation était simple.

Elle présentait cependant un énorme inconvénient.

Si une partition devenait trop petite…

…il fallait modifier toute la table GPT.

Autrement dit :

une simple augmentation de quelques mégaoctets pouvait nécessiter de reconstruire entièrement le firmware.

Google a donc complètement repensé cette architecture.

---

# L'arrivée de `super.img`

À partir d'Android 10, plusieurs partitions disparaissent physiquement.

À leur place apparaît une seule partition :

```
super
```

Cette partition n'est pas un système de fichiers.

Ce n'est pas non plus une image ext4.

C'est un **conteneur logique**.

À l'intérieur de celui-ci résident plusieurs partitions virtuelles.

---

# Notre première observation

Grâce à ADB root, nous avons identifié la présence de la partition :

```bash
ls -l /dev/block/by-name
```

Résultat :

```text
super -> /dev/block/mmcblk2p15
```

La taille observée était de :

```
2516582400 bytes
```

Soit exactement :

```
2 516 582 400 octets

≈ 2.34 Gio
```

Cette valeur est importante.

Elle correspond exactement à la taille du fichier :

```
super.img
```

que nous avons extrait puis reconstruit.

---

# Pourquoi un conteneur ?

Le principe est similaire à celui d'un disque virtuel.

Imaginez un disque de 2,5 Go.

À l'intérieur, Android crée plusieurs partitions.

```
super

├── system

├── vendor

├── odm

├── product

├── system_ext

├── vendor_dlkm

└── odm_dlkm
```

Ces partitions ne sont pas visibles dans la GPT.

Elles sont décrites dans des métadonnées internes.

---

# LPMetadata

Le cœur du système repose sur une structure appelée :

```
LPMetadata
```

Cette structure contient notamment :

- la liste des partitions logiques ;
- leur nom ;
- leur taille ;
- leur offset ;
- leurs groupes ;
- leurs extents.

Autrement dit :

Android ne "devine" pas où se trouve `system`.

Il lit cette table.

---

# Schéma interne

```
super.img

┌──────────────────────────────────────┐

│ LP Metadata                          │

├──────────────────────────────────────┤

│ system                               │

├──────────────────────────────────────┤

│ vendor                               │

├──────────────────────────────────────┤

│ odm                                  │

├──────────────────────────────────────┤

│ product                              │

├──────────────────────────────────────┤

│ system_ext                           │

├──────────────────────────────────────┤

│ vendor_dlkm                          │

├──────────────────────────────────────┤

│ odm_dlkm                             │

└──────────────────────────────────────┘
```

---

# Notre analyse

Après extraction du firmware nous avons utilisé :

```bash
lpunpack
```

afin de reconstruire la structure.

Les partitions suivantes furent obtenues.

```
system.img

vendor.img

product.img

system_ext.img

vendor_dlkm.img

odm.img

odm_dlkm.img
```

Cette étape confirmait que notre firmware respectait parfaitement le format officiel Android.

---

# Pourquoi Google a fait ce choix

Les partitions dynamiques résolvent plusieurs problèmes.

## 1 — Redimensionnement

Autrefois :

```
system = 2 Go

vendor = 500 Mo
```

Si `system` avait besoin de :

```
2.2 Go
```

il fallait modifier :

- GPT
- bootloader
- OTA

Aujourd'hui :

Android déplace simplement les limites logiques.

Aucune modification GPT n'est nécessaire.

---

## 2 — OTA

Les mises à jour OTA deviennent beaucoup plus simples.

Le constructeur peut :

- agrandir system ;
- réduire vendor ;
- ajouter product ;
- créer une nouvelle partition logique.

Tout cela sans toucher au partitionnement physique.

---

## 3 — Project Treble

Treble impose une séparation beaucoup plus stricte entre :

```
AOSP

et

Vendor
```

Les Dynamic Partitions rendent cette séparation beaucoup plus flexible.

---

# Les groupes

Une autre notion importante est celle de :

```
Partition Groups
```

Plusieurs partitions appartiennent au même groupe.

Elles se partagent un espace commun.

Exemple :

```
Group : main

system

vendor

product

odm
```

Si `vendor` devient plus petit…

`system` peut immédiatement récupérer l'espace libéré.

Cette souplesse explique pourquoi Android moderne est beaucoup plus facile à mettre à jour.

---

# Les extents

Une partition logique n'est pas obligée d'être stockée d'un seul bloc.

Elle peut être fragmentée.

Exemple :

```
system

Extent 1

Extent 2

Extent 3
```

Android reconstitue automatiquement la partition au montage.

Cette abstraction est totalement transparente.

---

# Pourquoi reconstruire `super.img` est difficile

Une erreur fréquente consiste à croire que :

```
cat system.img vendor.img > super.img
```

pourrait fonctionner.

C'est totalement faux.

Il faut reconstruire :

- les métadonnées ;
- les groupes ;
- les extents ;
- les offsets ;
- les alignements.

Pour cela Android fournit :

```
lpmake
```

---

# Notre méthode

Pendant cette étude nous avons adopté une règle stricte.

Avant toute reconstruction :

```
Extraction

↓

SHA256

↓

Comparaison

↓

Reconstruction

↓

Nouveau SHA256

↓

Validation
```

Cette approche a permis de vérifier que :

- chaque image extraite était correcte ;
- la reconstruction ne modifiait pas les données ;
- les erreurs provenaient uniquement des modifications volontaires.

---

# Pourquoi c'est important

Le firmware Ultimate repose entièrement sur cette compréhension.

Sans maîtriser :

- LPMetadata ;
- les groupes ;
- les extents ;
- `lpmake` ;
- `lpunpack` ;

il aurait été impossible de produire une ROM propre.

---

# Ce que nous avons confirmé

Notre enquête montre que le HY300 suit très fidèlement les recommandations de Google concernant les partitions dynamiques.

Le constructeur n'a pas remplacé ce mécanisme.

Il s'appuie directement sur l'implémentation officielle d'Android 12.

Cela constitue une excellente nouvelle.

Toutes les connaissances acquises sur les Dynamic Partitions Android restent applicables à ce projecteur.

---

# Résumé

Les Dynamic Partitions constituent aujourd'hui le cœur de l'architecture Android.

Elles permettent :

- des OTA plus fiables ;
- un meilleur partage de l'espace disque ;
- une séparation plus propre entre AOSP et les composants constructeur ;
- une reconstruction plus souple du firmware.

En contrepartie, elles rendent le reverse engineering plus exigeant.

Toute modification de `super.img` nécessite une parfaite compréhension des métadonnées qui décrivent sa structure.

---

> [!NOTE]
>
> Une partition logique n'existe pas physiquement sur l'eMMC. Elle n'est créée qu'au moment où Android interprète les métadonnées contenues dans `super.img`. Cette distinction est essentielle pour comprendre le fonctionnement des firmwares Android modernes.

---

# Chapitre suivant

➡️ **14 – System, Vendor, ODM et Product : comprendre la séparation introduite par Project Treble**