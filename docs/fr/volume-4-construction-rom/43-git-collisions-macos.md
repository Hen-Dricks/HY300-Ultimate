---
title: "Git, macOS et les difficultés d'un environnement de développement Android"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 43 — Git, macOS et les difficultés d'un environnement de développement Android

> *« Développer une ROM Android ne consiste pas uniquement à modifier des partitions. Une grande partie du travail consiste à construire un environnement de développement fiable et reproductible. »*

---

# Introduction

Le projet HY300 Ultimate a été développé principalement sous macOS.

Ce choix présentait plusieurs avantages :

- environnement Unix moderne ;
- excellente intégration avec Docker ;
- disponibilité des outils GNU via Homebrew ;
- performances élevées sur Apple Silicon.

Cependant, plusieurs difficultés spécifiques sont rapidement apparues.

Ce chapitre documente ces difficultés ainsi que les solutions retenues.

---

# Pourquoi utiliser Git ?

Toutes les modifications du firmware sont suivies avec Git.

Cela permet notamment :

- d'historiser chaque changement ;
- de revenir à une version précédente ;
- de comparer deux états du projet ;
- de faciliter les contributions externes.

Git constitue la colonne vertébrale du développement.

---

# Organisation du dépôt

Le dépôt Git contient :

```text
docs/
scripts/
docker/
assets/
workspace/
tools/
```

En revanche, certains éléments ne doivent jamais être versionnés.

Par exemple :

- images `super.img` ;
- partitions extraites ;
- sauvegardes brutes ;
- fichiers temporaires.

Ces fichiers sont ignorés grâce à `.gitignore`.

---

# Les collisions Git

Pendant le développement, plusieurs conflits sont apparus.

Les plus fréquents concernent :

- renommage de fichiers ;
- différences de casse ;
- changements simultanés ;
- conflits de fusion.

Ces situations sont normales dans un projet collaboratif.

---

# Le problème de la casse sous macOS

Par défaut, les systèmes de fichiers APFS et HFS+ sont **insensibles à la casse**.

Cela signifie que :

```text
Launcher.apk
```

et

```text
launcher.apk
```

sont considérés comme le même fichier.

Sous Linux, ces deux noms désignent pourtant deux fichiers distincts.

Ce comportement peut provoquer des conflits lors de la synchronisation d'un dépôt Git destiné à être utilisé sur plusieurs systèmes.

---

# Les fins de ligne

Windows utilise :

```
CRLF
```

Linux et macOS utilisent :

```
LF
```

Afin d'éviter les modifications inutiles, le dépôt définit un fichier :

```
.gitattributes
```

qui normalise les fins de ligne.

Exemple :

```text
*.sh text eol=lf
*.md text eol=lf
```

---

# Les permissions

Sous Linux, un script shell doit être exécutable.

Par exemple :

```bash
chmod +x scripts/build.sh
```

Git conserve cette information.

Il est important de vérifier que les permissions ne sont pas perdues lors des modifications.

---

# Les liens symboliques

Le projet utilise plusieurs liens symboliques.

Ils permettent notamment :

- d'éviter les duplications ;
- de simplifier certains scripts ;
- de conserver une arborescence claire.

Les liens doivent être testés sur toutes les plateformes.

---

# Docker

Une partie des différences entre macOS et Linux est éliminée grâce à Docker.

Toutes les commandes critiques sont exécutées dans le conteneur.

Cela garantit un comportement identique :

- sous macOS ;
- sous Linux ;
- sous Windows (via Docker Desktop ou WSL).

---

# Les fichiers volumineux

Les images de partitions représentent plusieurs gigaoctets.

Il est déconseillé de les versionner directement.

Le dépôt ne contient donc pas :

- `super.img`
- `system.img`
- `vendor.img`

À la place, seules les informations suivantes sont conservées :

- SHA-256 ;
- taille ;
- rapport d'extraction ;
- scripts permettant de reconstruire les images.

Cette approche limite la taille du dépôt tout en garantissant la reproductibilité.

---

# Git LFS

Git LFS a été étudié pour stocker certains artefacts volumineux.

Cependant, le projet privilégie la publication :

- des scripts ;
- des métadonnées ;
- des rapports ;
- des empreintes.

Les images complètes sont distribuées séparément lorsqu'elles peuvent l'être.

---

# Les bonnes pratiques retenues

Au cours du projet, plusieurs règles ont été adoptées.

- Une modification logique par commit.
- Des messages de commit explicites.
- Aucun binaire généré dans Git.
- Les scripts avant les artefacts.
- Les fichiers temporaires ignorés.

Ces règles facilitent les revues de code et la maintenance.

---

# Journal de développement

**Contexte**

Développement de HY300 Ultimate sur macOS.

**Difficultés rencontrées**

- différences entre APFS et ext4 ;
- gestion des permissions ;
- casse des noms de fichiers ;
- taille des artefacts ;
- partage entre plusieurs environnements.

**Solutions retenues**

- Docker pour l'environnement d'exécution ;
- `.gitignore` pour exclure les artefacts ;
- `.gitattributes` pour normaliser les fichiers texte ;
- archivage séparé des images système.

---

# Enseignements

Les difficultés rencontrées ne sont pas propres au HY300.

Elles apparaissent dans la plupart des projets de développement de firmware Android.

Documenter ces problèmes permet aux futurs contributeurs de reproduire l'environnement plus rapidement et d'éviter des erreurs fréquentes.

---

# Conclusion

Le développement d'une ROM Android moderne repose autant sur la qualité de l'environnement de travail que sur les modifications du firmware lui-même.

En documentant les contraintes liées à Git, à macOS et aux outils de développement, HY300 Ultimate vise à fournir un environnement reproductible, portable et accessible à l'ensemble de la communauté.

---

> [!TIP]
> Avant de commencer toute modification du firmware, prenez le temps de stabiliser votre environnement de développement. Un dépôt Git propre, un conteneur Docker reproductible et une gestion rigoureuse des artefacts vous feront gagner un temps considérable lors des phases de débogage et de collaboration.

---

# Chapitre suivant

➡️ **44 – Reconstruction finale de super.img**