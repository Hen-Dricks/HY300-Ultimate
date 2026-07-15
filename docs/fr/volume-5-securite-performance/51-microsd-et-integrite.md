---
title: "microSD et intégrité des données"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 51 — microSD et intégrité des données

> *« La meilleure analyse du monde ne vaut rien si les données étudiées ont été altérées pendant leur acquisition ou leur transfert. »*

---

# Résumé exécutif

Pendant le développement de HY300 Ultimate, une attention particulière a été portée à l'intégrité des données.

Chaque partition extraite, chaque image reconstruite et chaque artefact généré ont été considérés comme des éléments critiques.

L'objectif n'était pas seulement de conserver des copies du firmware, mais également de pouvoir démontrer que ces copies étaient fidèles à l'original.

Pour cela, plusieurs mécanismes ont été systématiquement utilisés :

- extraction sans modification de la source ;
- calcul d'empreintes cryptographiques ;
- archivage des métadonnées ;
- vérifications avant et après chaque transfert.

---

# Pourquoi parler de la microSD ?

La carte microSD occupe une place particulière dans l'écosystème Android embarqué.

Elle peut servir à :

- transférer des fichiers ;
- stocker des sauvegardes ;
- distribuer une mise à jour locale ;
- récupérer un firmware ;
- conserver des journaux d'analyse.

Contrairement aux partitions internes, elle est généralement amovible et facilement accessible.

---

# Objectifs

Notre utilisation de la microSD répond à plusieurs objectifs.

- Éviter de modifier les partitions internes pendant l'analyse.
- Conserver des sauvegardes indépendantes.
- Faciliter les transferts de gros fichiers.
- Préserver les artefacts de recherche.

---

# Les risques

Les principaux risques liés aux supports de stockage sont :

- corruption de fichiers ;
- copie incomplète ;
- erreur humaine ;
- défaillance du support ;
- confusion entre plusieurs versions.

Pour cette raison, aucune image n'est utilisée sans vérification préalable.

---

# Contrôle d'intégrité

Chaque fichier important reçoit une empreinte SHA-256.

Exemple :

```bash
sha256sum super.img

sha256sum system.img

sha256sum vendor.img
```

Ces empreintes sont conservées avec les artefacts du projet.

---

# Organisation des sauvegardes

Les sauvegardes sont organisées de manière à distinguer clairement les différentes étapes.

```text
backups/

├── original/
│   ├── super.img
│   ├── boot.img
│   ├── vendor.img
│   └── SHA256SUMS
│
├── modified/
│   ├── super-hy300-v01.img
│   ├── super-hy300-v02.img
│   └── SHA256SUMS
│
└── logs/
```

Cette séparation limite les risques de confusion.

---

# Vérification avant modification

Avant toute opération :

- la taille du fichier est vérifiée ;
- son empreinte est comparée à la valeur de référence ;
- une copie de travail est créée.

L'image originale n'est jamais modifiée.

---

# Vérification après transfert

Après chaque copie vers ou depuis un support externe, les vérifications sont répétées.

Les éléments contrôlés sont notamment :

- taille ;
- date ;
- empreinte SHA-256.

Cette étape permet de détecter rapidement une corruption ou une copie incomplète.

---

# Utilisation de la microSD

Dans le cadre du projet, la microSD est considérée comme un support de travail.

Elle peut accueillir :

- les sauvegardes du firmware ;
- les journaux ;
- les captures réseau ;
- les scripts ;
- les rapports.

Aucune donnée n'est supprimée sans avoir été archivée.

---

# Comparaison avec ADB

Les deux méthodes présentent des avantages différents.

| Critère                   | ADB        | microSD                           |
| ------------------------- | ---------- | --------------------------------- |
| Automatisation            | Excellente | Limitée                           |
| Débogage                  | Oui        | Non                               |
| Gros fichiers             | Moyen      | Excellent                         |
| Dépend du système Android | Oui        | Non (pour le stockage uniquement) |
| Archivage                 | Moyen      | Excellent                         |

Le choix dépend du contexte.

ADB reste privilégié pour l'analyse dynamique, tandis que la microSD est adaptée au transport et à l'archivage des artefacts.

---

# Gestion des versions

Chaque image est identifiée par :

- son nom ;
- sa version ;
- sa date de création ;
- son empreinte SHA-256.

Exemple :

```text
super-hy300-v0.2.img

SHA256 :

...

Date :

2026-07-14
```

Cette convention facilite le suivi des différentes builds.

---

# Journal de développement

**Objectif**

Garantir l'intégrité des données utilisées pendant le projet.

**Méthodologie**

Calcul systématique d'empreintes cryptographiques et archivage des sauvegardes.

**Résultat**

Une chaîne de conservation des données reproductible est mise en place.

---

# Enseignements

L'intégrité des données ne doit jamais être considérée comme acquise.

Même dans un environnement de développement local, une erreur de copie, une modification involontaire ou une corruption du support peuvent compromettre une analyse.

La vérification systématique des artefacts s'est révélée indispensable tout au long du projet.

---

# Bonnes pratiques retenues

- Ne jamais modifier une image originale.
- Calculer une empreinte SHA-256 avant et après chaque transfert.
- Conserver plusieurs copies des sauvegardes.
- Séparer clairement les images d'origine et les images modifiées.
- Documenter toutes les opérations importantes.

Ces règles ont été appliquées pendant toute la durée du développement de HY300 Ultimate.

---

# Conclusion

La réussite d'un projet de reverse engineering ne dépend pas uniquement des outils utilisés.

Elle repose également sur une gestion rigoureuse des données.

La combinaison de sauvegardes organisées, de contrôles cryptographiques et d'une stratégie d'archivage cohérente permet de garantir que chaque résultat présenté dans ce projet peut être retracé jusqu'à son origine.

---

## Tableau récapitulatif

| Élément                | Vérification | Statut |
| ---------------------- | ------------ | ------ |
| Images d'origine       | SHA-256      | ✓      |
| Images modifiées       | SHA-256      | ✓      |
| Sauvegardes            | Archivées    | ✓      |
| Structure des dossiers | Versionnée   | ✓      |
| Journal des opérations | Documenté    | ✓      |

---

> [!TIP]
> Une empreinte SHA-256 ne protège pas un fichier contre la corruption ; elle permet de **la détecter** avec une très forte probabilité. C'est pourquoi chaque transfert important doit être suivi d'une nouvelle vérification d'intégrité.

---

# Chapitre suivant

➡️ **52 – Performance Baseline : établir une référence avant toute optimisation**