---
title: "Annexe D — Hashes de référence"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "fr"
last_updated: "2026-07-14"
---

# Annexe D — Hashes de référence

> *« Un artefact sans empreinte cryptographique est difficile à vérifier. Une empreinte seule ne prouve pas l'origine d'un fichier, mais elle permet de garantir que son contenu n'a pas été modifié depuis son calcul. »*

---

# Objectif

Cette annexe centralise les empreintes cryptographiques des principaux artefacts utilisés ou produits au cours du projet HY300 Ultimate.

Elle poursuit plusieurs objectifs :

- vérifier l'intégrité des fichiers ;
- distinguer les différentes versions ;
- garantir la reproductibilité des expérimentations ;
- faciliter les comparaisons entre builds.

Toutes les empreintes publiées dans cette annexe sont calculées avec **SHA-256**, sauf indication contraire.

---

# Pourquoi utiliser SHA-256 ?

SHA-256 est une fonction de hachage cryptographique largement utilisée pour vérifier l'intégrité des fichiers.

Dans ce projet, elle permet de détecter :

- une corruption lors d'un transfert ;
- une modification involontaire ;
- une confusion entre plusieurs versions.

Deux fichiers identiques produisent la même empreinte.

Une modification, même minime, produit une empreinte complètement différente.

---

# Commandes utilisées

Calcul d'une empreinte SHA-256.

```bash
sha256sum fichier.img
```

Sous macOS.

```bash
shasum -a 256 fichier.img
```

Calcul de plusieurs fichiers.

```bash
sha256sum *.img
```

Création d'un fichier de référence.

```bash
sha256sum *.img > SHA256SUMS
```

Vérification.

```bash
sha256sum -c SHA256SUMS
```

---

# Convention de nommage

Les artefacts suivent une convention commune.

```
nom-version.img
```

Exemples :

```
super-original.img

super-hy300-v0.1.img

super-hy300-v0.2.img
```

Cette convention facilite la traçabilité.

---

# Firmware constructeur

| Fichier            |      Taille | SHA-256     | Statut    |
| ------------------ | ----------: | ----------- | --------- |
| super-original.img | À compléter | À compléter | Référence |
| boot.img           | À compléter | À compléter | Référence |
| vendor.img         | À compléter | À compléter | Référence |
| product.img        | À compléter | À compléter | Référence |
| odm.img            | À compléter | À compléter | Référence |
| vbmeta.img         | À compléter | À compléter | Référence |

---

# Partitions extraites

| Partition   |      Taille | SHA-256     |
| ----------- | ----------: | ----------- |
| system.img  | À compléter | À compléter |
| vendor.img  | À compléter | À compléter |
| product.img | À compléter | À compléter |
| odm.img     | À compléter | À compléter |

---

# Builds HY300 Ultimate

| Build | SHA-256     | Date        | Statut       |
| ----- | ----------- | ----------- | ------------ |
| v0.1  | À compléter | À compléter | Prototype    |
| v0.2  | À compléter | À compléter | Experimental |
| v0.3  | À compléter | À compléter | Prévue       |
| RC1   | À compléter | À compléter | Prévue       |
| v1.0  | À compléter | À compléter | Prévue       |

---

# Scripts

Les scripts importants peuvent également être référencés.

| Script      | SHA-256     |
| ----------- | ----------- |
| build.sh    | À compléter |
| extract.sh  | À compléter |
| rebuild.sh  | À compléter |
| validate.sh | À compléter |

---

# Docker

Les fichiers Docker utilisés peuvent être suivis.

| Fichier            | SHA-256     |
| ------------------ | ----------- |
| Dockerfile         | À compléter |
| docker-compose.yml | À compléter |

---

# Documentation

Les principaux documents peuvent recevoir une empreinte lors de chaque publication.

| Document     | SHA-256     |
| ------------ | ----------- |
| README.md    | À compléter |
| CHANGELOG.md | À compléter |
| RELEASE.md   | À compléter |

---

# Vérification avant publication

Avant chaque release :

```text
Firmware

↓

SHA-256

↓

Comparaison

↓

Validation

↓

Publication
```

Aucun artefact n'est publié sans vérification préalable.

---

# Gestion des versions

Les empreintes ne sont jamais remplacées.

Lorsqu'une nouvelle build est produite :

- une nouvelle entrée est ajoutée ;
- les anciennes restent archivées.

Cette politique garantit la traçabilité historique du projet.

---

# Organisation recommandée

```
release/

├── SHA256SUMS
├── SHA256SUMS.txt
├── build-report.md
├── RELEASE.md
└── CHANGELOG.md
```

Le fichier `SHA256SUMS` accompagne systématiquement les artefacts distribués.

---

# Exemple de fichier SHA256SUMS

```text
9d3d...a8e2  super-original.img
51af...0b9c  super-hy300-v0.1.img
7e29...8fa1  super-hy300-v0.2.img
```

Les valeurs ci-dessus sont fournies uniquement à titre d'exemple.

---

# Vérification d'une release

Après téléchargement :

```bash
sha256sum -c SHA256SUMS
```

Résultat attendu.

```text
super-hy300-v0.2.img: OK
```

Toute différence doit être considérée comme un signal d'alerte et faire l'objet d'une vérification avant utilisation.

---

# Tableau récapitulatif

| Catégorie     | Vérification |
| ------------- | ------------ |
| Firmware OEM  | SHA-256      |
| Partitions    | SHA-256      |
| Builds        | SHA-256      |
| Scripts       | SHA-256      |
| Docker        | SHA-256      |
| Documentation | SHA-256      |

---

# Bonnes pratiques

- Calculer les empreintes immédiatement après la génération des fichiers.
- Vérifier les empreintes après chaque transfert important.
- Conserver les fichiers `SHA256SUMS` avec les artefacts correspondants.
- Ne jamais remplacer une empreinte historique.
- Utiliser exclusivement SHA-256 comme référence principale dans le projet.

---

# Commandes réellement utilisées dans HY300 Ultimate

Cette section recensera les commandes réellement exécutées pour générer et vérifier les empreintes des artefacts.

Elle sera complétée au fur et à mesure des différentes builds.

---

# Historique des révisions

| Version | Date        | Évolution                                                   |
| ------- | ----------- | ----------------------------------------------------------- |
| 1.0     | 2026-07-14  | Création de l'annexe                                        |
| 1.x     | À compléter | Ajout progressif des empreintes des builds et des artefacts |

---

> [!IMPORTANT]
> Les empreintes cryptographiques publiées dans cette annexe permettent de vérifier l'intégrité des artefacts distribués. Elles ne constituent pas un mécanisme d'authentification à elles seules. Pour une diffusion publique, elles peuvent être complétées par une signature numérique (par exemple GPG ou un autre mécanisme de signature adapté au projet) afin de garantir également l'authenticité des fichiers.