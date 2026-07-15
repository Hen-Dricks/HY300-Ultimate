---
title: "Stratégie de sauvegarde avant toute modification"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 34 — Stratégie de sauvegarde

> *« La première règle du reverse engineering est simple : ne jamais modifier un système avant d'avoir démontré qu'il est possible de revenir exactement à son état d'origine. »*

---

# Introduction

La construction d'une ROM personnalisée commence bien avant la première modification du firmware.

Contrairement à une idée répandue, la difficulté principale n'est pas de modifier Android.

La difficulté est de pouvoir revenir en arrière.

Une erreur de quelques octets dans une partition système peut empêcher totalement le démarrage du projecteur.

La première étape de ce projet a donc consisté à mettre en place une stratégie de sauvegarde complète.

Cette stratégie nous a permis de travailler sereinement tout au long du développement du firmware HY300 Ultimate.

---

# Philosophie

Chaque opération de modification devait respecter quatre principes.

## 1. Aucune donnée ne doit être perdue

Chaque partition importante devait être sauvegardée avant toute écriture.

---

## 2. Les sauvegardes doivent être vérifiables

Une sauvegarde n'a aucune valeur si son intégrité n'est pas contrôlée.

Chaque image est donc accompagnée :

- de sa taille exacte ;
- de son empreinte SHA-256 ;
- de sa date d'extraction.

---

## 3. Les sauvegardes doivent être restaurables

Une image inutilisable n'est pas une sauvegarde.

Toutes les sauvegardes sont conservées au format brut (`.img`) afin de pouvoir être réécrites directement sur le support d'origine.

---

## 4. Les opérations doivent être reproductibles

Toutes les commandes utilisées dans ce projet sont documentées.

Un lecteur possédant le même matériel doit pouvoir reproduire exactement les mêmes sauvegardes.

---

# Pourquoi sauvegarder autant ?

Le firmware du HY300 est réparti sur plusieurs partitions.

Toutes n'ont pas la même importance.

Certaines contiennent :

- le noyau Linux ;
- Android ;
- les applications ;
- les données utilisateur ;
- les paramètres du constructeur.

Une modification sur l'une d'elles peut avoir des conséquences sur l'ensemble du système.

---

# Notre stratégie

Nous avons distingué trois niveaux de sauvegarde.

## Niveau 1 — Partitions critiques

Les partitions indispensables au démarrage.

Exemples :

```text
boot

vbmeta

misc

super

recovery
```

---

## Niveau 2 — Configuration constructeur

Les partitions contenant des paramètres spécifiques au constructeur.

Par exemple :

```text
backup

cust

baseparameter

metadata
```

---

## Niveau 3 — Sauvegarde documentaire

En parallèle des images brutes, nous avons conservé :

- les empreintes SHA-256 ;
- les tailles exactes ;
- les journaux de commandes ;
- les captures d'écran ;
- les sorties ADB.

Cette documentation permet de démontrer que les images utilisées correspondent bien au firmware étudié.

---

# Sauvegarde de la partition `super`

L'un des éléments les plus importants de cette étude est la partition `super`.

Avant toute modification, nous avons :

1. identifié sa taille ;
2. vérifié son intégrité ;
3. copié l'image sur une carte microSD ;
4. contrôlé la copie à l'aide d'une empreinte SHA-256.

Cette précaution a permis de disposer d'une image de référence avant toute expérimentation.

---

# Vérification des sauvegardes

Une sauvegarde n'est considérée comme valide qu'après plusieurs contrôles.

## Taille

La taille de l'image doit correspondre exactement à celle de la partition d'origine.

---

## Lecture complète

L'image doit pouvoir être relue jusqu'à son dernier octet.

Cette vérification permet de détecter les copies incomplètes.

---

## Empreinte cryptographique

Chaque image est accompagnée d'une empreinte SHA-256.

Cette empreinte garantit que le contenu n'a pas été modifié.

---

# Organisation des sauvegardes

Toutes les images sont stockées dans une arborescence claire.

```text
backup/

├── partitions/
│   ├── boot.img
│   ├── misc.img
│   ├── backup.img
│   ├── cust.img
│   ├── vbmeta.img
│   └── super.img
│
├── hashes/
│   ├── SHA256SUMS
│   └── SHA256SUMS.txt
│
└── metadata/
    ├── partition-layout.md
    ├── extraction-log.txt
    └── device-info.md
```

Cette organisation simplifie les comparaisons entre différentes versions du firmware.

---

# Les erreurs que nous voulions éviter

Plusieurs erreurs classiques peuvent rendre un firmware inutilisable :

- modifier une partition sans sauvegarde préalable ;
- écraser une image valide par erreur ;
- perdre la correspondance entre une image et sa partition ;
- utiliser une sauvegarde incomplète.

Notre stratégie vise à éliminer ces risques.

---

# Bonnes pratiques

Tout au long du projet, nous avons appliqué les règles suivantes :

- ne jamais modifier l'image originale ;
- travailler sur une copie ;
- conserver plusieurs versions importantes ;
- documenter chaque modification ;
- vérifier systématiquement les empreintes.

Ces pratiques facilitent également le travail collaboratif.

---

# Conclusion

La sauvegarde constitue la base de tout projet de modification de firmware.

Elle ne représente pas une étape secondaire mais la condition indispensable à toute expérimentation.

Grâce à cette stratégie, chaque modification apportée au firmware HY300 Ultimate pourra être comparée à l'état d'origine et, si nécessaire, annulée de manière fiable.

---

> [!TIP]
> Avant de modifier une seule ligne de code ou un seul octet d'une image système, assurez-vous de disposer d'une sauvegarde vérifiée, documentée et restaurable. Cette précaution vous fera gagner un temps considérable en cas d'erreur.

---

# Chapitre suivant

➡️ **35 – Dump des partitions : extraction complète du firmware via ADB et accès root**