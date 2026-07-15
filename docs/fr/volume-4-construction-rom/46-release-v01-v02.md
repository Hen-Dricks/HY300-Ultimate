---
title: "Historique des builds : HY300 Ultimate v0.1 et v0.2"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 46 — Historique des builds : v0.1 et v0.2

> *« Une build n'est pas uniquement une version du firmware. C'est un instantané de l'ensemble des décisions techniques prises à un moment précis du projet. »*

---

# Introduction

Le développement de HY300 Ultimate s'est déroulé de manière incrémentale.

Chaque build a été construite avec un objectif précis :

- comprendre le firmware ;
- sécuriser les manipulations ;
- réduire progressivement les composants inutiles ;
- améliorer l'expérience utilisateur ;
- conserver une stabilité maximale.

Ce chapitre retrace l'évolution des premières versions du projet.

---

# Politique de versionnement

Le projet adopte un versionnement simple.

```
v0.x

↓

Prototype

↓

Validation technique

↓

RC

↓

Stable

↓

v1.0
```

Les premières versions ne sont pas destinées à une diffusion massive.

Elles servent principalement à :

- tester les modifications ;
- mesurer leur impact ;
- valider la méthodologie.

---

# Build v0.1

## Objectif

La version **v0.1** constitue la première reconstruction complète du firmware.

Elle ne cherche pas encore à optimiser le système.

Son objectif principal est de démontrer que l'ensemble de la chaîne de développement fonctionne.

---

## Base

```
Firmware constructeur HY300
```

---

## Modifications

- reconstruction de `super.img` ;
- validation des partitions ;
- conservation des applications OEM ;
- aucune optimisation majeure.

---

## Validation

| Élément        | État         |
| -------------- | ------------ |
| Reconstruction | ✓            |
| Extraction     | ✓            |
| Flash          | À documenter |
| Boot           | À documenter |
| Launcher       | OEM          |
| Keystone       | À documenter |
| Autofocus      | À documenter |

---

## Enseignements

Cette première build permet principalement de valider :

- l'environnement de travail ;
- les scripts ;
- la reconstruction des partitions dynamiques ;
- la procédure de flash.

Elle constitue la référence de départ du projet.

---

# Build v0.2

## Objectif

La version **v0.2** marque le début des modifications fonctionnelles.

L'objectif est de produire un firmware plus léger tout en conservant l'ensemble des fonctions essentielles du projecteur.

---

## Modifications prévues

- premières suppressions d'applications OEM validées ;
- intégration de Projectivy Launcher ;
- optimisation de certains paramètres système ;
- poursuite de l'analyse des composants propriétaires.

Les modifications effectivement intégrées seront documentées une fois validées.

---

## Validation

| Élément        | État               |
| -------------- | ------------------ |
| Reconstruction | À documenter       |
| Flash          | À documenter       |
| Boot           | À documenter       |
| Launcher       | Projectivy (prévu) |
| Wi-Fi          | À documenter       |
| Bluetooth      | À documenter       |
| Keystone       | À documenter       |
| Autofocus      | À documenter       |

---

# Comparaison

| Fonction                  |  OEM  | v0.1  |   v0.2   |
| ------------------------- | :---: | :---: | :------: |
| Reconstruction complète   |   —   |   ✓   |    ✓     |
| Validation des partitions |   —   |   ✓   |    ✓     |
| Nettoyage OEM             |   —   |   ✗   | En cours |
| Projectivy Launcher       |   ✗   |   ✗   |  Prévu   |
| Documentation complète    |   ✗   |   ✓   |    ✓     |

---

# Méthode de validation

Chaque build suit exactement le même protocole.

```
Extraction

↓

Modification

↓

Reconstruction

↓

Validation

↓

Flash

↓

Tests

↓

Documentation

↓

Publication
```

Aucune version n'est publiée sans avoir parcouru l'ensemble de ces étapes.

---

# Gestion des artefacts

Chaque build publiée est accompagnée :

```
release/

├── build-report.md
├── SHA256SUMS
├── CHANGELOG.md
├── release-notes.md
├── screenshots/
├── logs/
└── validation/
```

Cette organisation garantit la traçabilité de chaque version.

---

# Politique de publication

Toutes les builds ne sont pas destinées à être téléchargées.

Le projet distingue plusieurs statuts.

| Statut                 | Description                             |
| ---------------------- | --------------------------------------- |
| Prototype              | Essais internes                         |
| Experimental           | Fonctionnel mais incomplet              |
| RC (Release Candidate) | Prêt pour validation finale             |
| Stable                 | Recommandé pour une utilisation normale |

---

# Journal de développement

**Période**

Premières builds du projet HY300 Ultimate.

**Objectif**

Valider la chaîne complète de construction du firmware.

**Résultats**

- reconstruction maîtrisée ;
- méthodologie stabilisée ;
- documentation structurée ;
- premières optimisations en préparation.

---

# Ce que nous avons appris

Les premières builds ont montré que la difficulté principale ne réside pas dans la modification d'Android.

Elle réside dans :

- la compréhension du firmware ;
- la maîtrise des partitions dynamiques ;
- la reproductibilité des opérations ;
- la validation systématique après chaque changement.

Ces enseignements ont orienté toute la suite du projet.

---

# Perspectives

Les prochaines builds auront pour objectifs :

- finaliser le nettoyage des composants OEM ;
- intégrer de nouvelles optimisations ;
- améliorer les performances ;
- renforcer la stabilité ;
- préparer la première version stable.

Chaque évolution sera documentée avec le même niveau de détail que les versions précédentes.

---

# Conclusion

Les versions **v0.1** et **v0.2** représentent les premières étapes concrètes de HY300 Ultimate.

Elles ne sont pas seulement des versions du firmware.

Elles constituent les premiers jalons d'un processus de développement reproductible, documenté et ouvert à la communauté.

Grâce à cette approche, chaque build pourra être comparée, auditée et améliorée au fil du temps.

---

> [!NOTE]
> Les tableaux de validation de ce chapitre sont volontairement laissés partiellement ouverts. Ils seront complétés au fur et à mesure des essais réalisés sur le matériel réel. Cette approche permet de distinguer clairement les fonctionnalités effectivement validées de celles qui restent en cours d'évaluation.

---

# Chapitre suivant

➡️ **47 – Conclusions du Volume IV**