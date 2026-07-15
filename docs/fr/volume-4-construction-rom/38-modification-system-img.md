---
title: "Modification de system.img"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 38 — Modification de system.img

> *« Comprendre un firmware est une étape. Le transformer sans le casser en est une autre. »*

---

# Introduction

Après plusieurs semaines consacrées à l'analyse du firmware d'origine, nous sommes enfin prêts à effectuer les premières modifications.

Cette étape marque la naissance du projet **HY300 Ultimate**.

Jusqu'à présent :

- aucune donnée n'a été modifiée ;
- toutes les analyses étaient réalisées sur une copie du firmware ;
- l'objectif était uniquement de comprendre le fonctionnement du système.

À partir de ce chapitre, nous allons commencer à transformer progressivement le firmware constructeur en une ROM optimisée.

---

# Philosophie

Une règle guidera toutes les modifications.

> **Une seule modification à la fois.**

Pourquoi ?

Parce que lorsqu'une ROM ne démarre plus, il devient pratiquement impossible de déterminer quelle modification en est responsable si plusieurs changements ont été réalisés simultanément.

Chaque modification est donc :

- isolée ;
- documentée ;
- validée ;
- archivée.

---

# Préparation de l'image

Après extraction avec `lpunpack`, nous obtenons :

```text
system.img
```

Avant toute modification, cette image est copiée.

```
system.img

↓

system-working.img
```

L'image originale n'est jamais modifiée.

---

# Vérification

Avant montage :

```bash
file system-working.img

sha256sum system-working.img

e2fsck -fn system-working.img
```

Objectifs :

- vérifier qu'il s'agit bien d'une image ext4 ;
- enregistrer son empreinte ;
- contrôler son intégrité.

---

# Montage

Une fois vérifiée :

```bash
sudo mount \
-o loop \
system-working.img \
mnt/system
```

Nous obtenons alors :

```text
mnt/system/

app/

bin/

etc/

framework/

fonts/

lib/

priv-app/

usr/

xbin/
```

Le système Android devient accessible comme un simple répertoire Linux.

---

# Organisation

Toutes les modifications sont réalisées dans :

```
workspace/

↓

mounted/

↓

system/
```

Aucun fichier n'est édité directement dans l'image.

---

# Première inspection

Avant toute suppression :

```bash
find app

find priv-app

find framework

find bin
```

Chaque composant est inventorié.

---

# Cartographie

Chaque élément reçoit une fiche.

Exemple :

| Élément     | Fonction   | Décision   |
| ----------- | ---------- | ---------- |
| Launcher    | Interface  | conserver  |
| QuickShare  | Projection | conserver  |
| TXCZ OTA    | OTA        | à analyser |
| Daemon12138 | Service    | à étudier  |

Cette cartographie servira tout au long du projet.

---

# Pourquoi modifier system.img ?

Toutes les personnalisations de HY300 Ultimate passeront principalement par :

- suppression d'applications ;
- ajout d'applications ;
- modification des paramètres système ;
- remplacement de bibliothèques ;
- optimisation des services.

Le choix de `system.img` comme point d'entrée permet de limiter les risques avant d'envisager des modifications plus profondes.

---

# Règles

Chaque modification devra répondre à quatre critères.

## Réversible

Retour arrière immédiat.

---

## Documentée

Toutes les commandes sont conservées.

---

## Justifiée

Chaque suppression doit être expliquée.

---

## Testée

Le firmware doit redémarrer après chaque changement.

---

# Validation

Après chaque modification :

```bash
e2fsck

resize2fs

sha256sum
```

sont exécutés.

Puis l'image est remontée.

---

# Reconstruction

Une fois toutes les modifications validées :

```
system.img

↓

lpmake

↓

super.img
```

Cette étape sera étudiée dans un chapitre dédié.

---

# Journal de développement

**Date**

2026-07-14

**Objectif**

Préparer la première image système modifiable.

**Résultat**

✓ image copiée

✓ intégrité validée

✓ montage réalisé

✓ arborescence inspectée

✓ stratégie de modification définie

**Décision**

Toutes les modifications futures seront atomiques.

Une seule modification sera introduite avant chaque reconstruction du firmware.

---

# Ce que nous avons appris

Modifier Android est beaucoup plus simple lorsqu'on considère le firmware comme un système de fichiers Linux classique.

Le vrai défi n'est pas l'édition des fichiers.

Le vrai défi consiste à conserver :

- la cohérence de l'image ;
- les permissions ;
- les contextes SELinux ;
- la compatibilité avec les partitions dynamiques.

---

# Conclusion

Ce chapitre marque la transition entre l'analyse et la construction.

À partir de maintenant, HY300 Ultimate n'est plus seulement un projet de reverse engineering.

Il devient un véritable projet de développement de firmware.

Toutes les optimisations qui suivront seront réalisées sur cette base de travail.

---

> [!SUCCESS]
> La première image système de travail est désormais prête. Les prochains chapitres détailleront chaque modification apportée au firmware constructeur, leurs motivations, leur mise en œuvre et leur validation.

---

# Chapitre suivant

➡️ **39 – Neutralisation de Daemon12138 : analyse d'impact, méthodologie et validation**