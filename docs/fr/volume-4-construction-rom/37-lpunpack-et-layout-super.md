---
title: "Décomposition de super.img avec lpunpack"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 37 — Décomposition de super.img avec lpunpack

> *« Depuis Android 10, le système n'est plus constitué d'une simple partition system. Il est devenu un ensemble de partitions logiques regroupées dans un conteneur unique appelé super. Comprendre cette évolution est indispensable avant toute modification d'un firmware moderne. »*

---

# Introduction

L'une des plus grandes évolutions introduites par Android est le remplacement des partitions système fixes par des **partitions dynamiques**.

Au lieu de posséder plusieurs partitions physiques indépendantes (`system`, `vendor`, `product`, `odm`, etc.), Android regroupe désormais ces partitions dans une unique partition physique :

```
super
```

Cette architecture offre une plus grande flexibilité mais complexifie considérablement le travail de reverse engineering.

Avant toute modification, il est donc indispensable de comprendre sa structure.

---

# Pourquoi Android a introduit les partitions dynamiques ?

Les anciennes générations d'appareils souffraient d'un problème majeur.

Chaque partition possédait une taille fixe.

Par exemple :

```
system : 2 Go

vendor : 600 Mo

product : 400 Mo
```

Si :

```
system

↓

avait besoin de

↓

2,1 Go
```

la mise à jour devenait impossible.

À l'inverse,

plusieurs centaines de mégaoctets pouvaient rester inutilisés dans `vendor`.

Les partitions dynamiques résolvent ce problème.

---

# Architecture générale

Au lieu d'utiliser plusieurs partitions physiques :

```
eMMC

↓

system

vendor

product

odm
```

Android utilise désormais :

```
eMMC

↓

super

↓

LP Metadata

↓

Partitions logiques

↓

system

vendor

product

odm
```

---

# Notre firmware

Lors de notre étude, nous avons identifié :

```
/dev/block/by-name/super
```

Cette partition correspond à :

```
/dev/block/mmcblk2p15
```

Sa taille est :

```
2516582400 bytes
```

Cette valeur a été vérifiée avant toute manipulation.

---

# Sauvegarde préalable

Avant d'utiliser `lpunpack`, plusieurs vérifications ont été réalisées.

## Taille

```
2516582400 bytes
```

---

## Lecture complète

La fin de l'image a été relue avec succès.

---

## SHA-256

```
5f20192019b99340821ad34b4f86cb7c2f2588f411f5a05bb501408916dc35cf
```

Cette empreinte constitue désormais la référence officielle du projet.

---

# Pourquoi utiliser lpunpack ?

Le fichier :

```
super.img
```

n'est pas directement montable.

Il contient plusieurs partitions logiques.

Avant toute modification,

il faut les extraire.

Android fournit pour cela :

```
lpunpack
```

---

# Principe de fonctionnement

```
super.img

↓

LP Metadata

↓

Lecture du layout

↓

Extraction

↓

system.img

vendor.img

product.img

odm.img
```

Chaque image pourra ensuite être étudiée indépendamment.

---

# Les métadonnées LP

Avant d'accéder aux partitions,

`lpunpack` lit une structure appelée :

```
LP Metadata
```

Cette structure contient notamment :

- la liste des partitions logiques ;
- leurs offsets ;
- leurs tailles ;
- leurs groupes ;
- leurs attributs.

Elle constitue la carte routière du firmware.

---

# Les groupes

Android introduit également la notion de groupes.

Exemple simplifié :

```
Group default

↓

system

vendor

product
```

Le groupe définit une limite globale de taille.

Cette architecture facilite les mises à jour OTA.

---

# Pourquoi est-ce important ?

Lors de la reconstruction,

nous ne pourrons pas agrandir une partition arbitrairement.

Nous devrons respecter :

- la taille du groupe ;
- la taille globale de `super` ;
- les contraintes imposées par `lpmake`.

---

# Les partitions logiques

Après extraction,

nous obtenons généralement :

```
system.img

vendor.img

product.img

odm.img

system_ext.img
```

La liste exacte dépend du firmware étudié.

Chaque image pourra être montée séparément.

---

# Analyse de la disposition

Une fois les partitions extraites,

nous documenterons pour chacune :

| Partition | Taille | Type    | Système de fichiers |
| --------- | -----: | ------- | ------------------- |
| system    |    ... | Logical | ext4                |
| vendor    |    ... | Logical | ext4                |
| product   |    ... | Logical | ext4                |
| odm       |    ... | Logical | ext4                |

Ces informations serviront à la reconstruction.

---

# Les erreurs classiques

Plusieurs erreurs reviennent régulièrement.

## Modifier directement super.img

Très mauvaise idée.

Toujours extraire les partitions logiques.

---

## Oublier les métadonnées LP

Les partitions seules ne suffisent pas.

Le layout devra être reconstruit exactement.

---

## Ignorer les groupes

Une image plus volumineuse peut empêcher totalement la reconstruction.

---

## Dépasser la taille de super

La somme des partitions reconstruites devra toujours rester compatible avec la taille totale de `super`.

---

# Journal de développement

**Date :**

2026-07-14

**Objectif :**

Préparer l'extraction des partitions logiques.

**Résultat :**

✓ Image `super.img` validée.

✓ Taille contrôlée.

✓ Lecture complète réalisée.

✓ SHA-256 enregistré.

✓ Environnement prêt pour `lpunpack`.

**Décision :**

Aucune modification ne sera effectuée directement sur `super.img`.

Toutes les modifications porteront exclusivement sur les partitions logiques extraites.

---

# Conclusion

La partition `super` constitue le cœur du firmware Android moderne.

Avant toute personnalisation, il est indispensable de comprendre son organisation interne et le rôle des métadonnées LP.

Cette étape marque le passage entre la simple analyse du firmware et sa modification effective.

Les chapitres suivants utiliseront les partitions extraites pour commencer la construction du firmware **HY300 Ultimate**.

---

> [!IMPORTANT]
> Le succès de la reconstruction dépend directement du respect du layout d'origine. Modifier correctement `system.img` n'est qu'une partie du travail : il faudra également reconstruire un conteneur `super.img` cohérent avec ses métadonnées et les contraintes imposées par Android.

---

# Chapitre suivant

➡️ **38 – Modification de system.img : personnalisation, nettoyage et préparation de HY300 Ultimate**