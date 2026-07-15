---
title: "Keystone : architecture interne et propriétés système"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 28 — Keystone : architecture interne et propriétés système

> *« Pour l'utilisateur, la correction trapézoïdale est une simple option. Pour Android, elle est le résultat de plusieurs couches logicielles travaillant simultanément. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre le fonctionnement général de Keystone ;
- identifier les propriétés Android utilisées par le constructeur ;
- comprendre comment Android pilote la correction géométrique ;
- reproduire les observations sur un autre appareil Android.

---

# Introduction

L'une des principales caractéristiques d'un vidéoprojecteur est sa capacité à corriger automatiquement la géométrie de l'image.

Lorsque l'appareil est placé de travers, l'image projetée prend naturellement une forme trapézoïdale.

Le système Keystone compense cette déformation.

Sur le HY300, cette fonctionnalité repose sur plusieurs composants :

- applications Android ;
- services système ;
- bibliothèques natives ;
- propriétés Android ;
- pilotes matériels.

Notre objectif est de comprendre leur interaction.

---

# Qu'est-ce que Keystone ?

La correction trapézoïdale consiste à transformer numériquement l'image avant son affichage.

Au lieu d'afficher un rectangle parfait, le projecteur calcule une nouvelle géométrie afin que l'image projetée retrouve une forme rectangulaire.

Schéma simplifié :

```
Image originale

██████████

↓

Transformation géométrique

↓

Image corrigée

╱████████╲
│████████│
╲████████╱
```

Cette opération est réalisée en temps réel.

---

# Architecture générale

Les observations réalisées jusqu'à présent permettent de proposer l'architecture suivante.

```
Utilisateur

↓

Launcher

↓

Application Keystone

↓

Binder

↓

Keystone Service

↓

Bibliothèque native

↓

SurfaceFlinger

↓

GPU Rockchip

↓

Sortie HDMI / LCD
```

Certaines étapes restent à confirmer expérimentalement.

---

# Les propriétés Android

Android utilise un système centralisé de propriétés.

Ces propriétés permettent aux différents composants de partager des informations.

Les commandes principales sont :

```bash
getprop

setprop
```

Durant l'étude, toutes les propriétés liées à Keystone seront recensées.

---

# Méthodologie

Les recherches seront effectuées selon plusieurs approches.

## Recherche des propriétés

```bash
getprop | grep -i key

getprop | grep -i trap

getprop | grep -i auto

getprop | grep -i focus
```

---

## Recherche dans les APK

Les chaînes suivantes seront recherchées.

```
keystone

trap

focus

projection

geometry

warp
```

---

## Recherche JNI

Les bibliothèques natives seront analysées.

Objectifs :

- identifier les appels JNI ;
- retrouver les méthodes natives ;
- comprendre les interactions avec le GPU.

---

# Classification des propriétés

Chaque propriété sera documentée sous la forme suivante.

---

## Exemple de fiche

### Nom

```
persist.keystone.example
```

### Valeur observée

```
true
```

### Source

```
getprop
```

### Lecture par

```
APK Keystone
```

### Modification par

```
Launcher
```

### Effet

```
Active la correction automatique.
```

### Niveau de confiance

```
À confirmer
```

---

# Pourquoi utiliser des propriétés ?

Android privilégie les propriétés pour plusieurs raisons.

Elles permettent :

- une communication rapide entre processus ;
- une configuration persistante ;
- un accès simple depuis Java et le natif ;
- une intégration directe avec `init`.

Cette approche est largement utilisée dans les firmwares constructeurs.

---

# Les composants impliqués

À ce stade de l'étude, plusieurs catégories de composants sont identifiées.

## Interface utilisateur

Responsable des réglages.

---

## Service système

Responsable des calculs.

---

## Bibliothèque native

Responsable des transformations géométriques.

---

## SurfaceFlinger

Responsable de l'affichage.

---

## GPU

Responsable du rendu final.

---

# Les calculs géométriques

Une correction Keystone nécessite plusieurs étapes.

```
Capteurs

↓

Calcul des angles

↓

Calcul de la matrice

↓

Transformation

↓

Affichage
```

Selon les constructeurs, certains calculs sont effectués :

- en Java ;
- en C++;
- directement par le GPU.

Le firmware du HY300 devra être analysé afin d'identifier précisément le chemin retenu.

---

# Binder

Une partie importante de l'étude consistera à comprendre :

```
Launcher

↓

Binder

↓

Keystone Service
```

Les appels Binder seront documentés.

Nous chercherons :

- les interfaces AIDL ;
- les services enregistrés ;
- les transactions.

---

# Bibliothèques natives

Les recherches porteront notamment sur :

```
libkeystone.so

libprojector.so

librkgfx.so
```

Les noms exacts dépendront du firmware.

Chaque bibliothèque sera étudiée.

---

# Analyse dynamique

Les essais comprendront :

- activation de Keystone ;
- désactivation ;
- correction manuelle ;
- correction automatique.

Pendant ces essais :

```bash
logcat

getprop

dumpsys
```

seront enregistrés.

L'objectif est de relier les événements utilisateur aux modifications internes.

---

# Ce que nous savons déjà

## Faits

- Le HY300 possède une correction trapézoïdale.
- Plusieurs composants OEM y participent.
- Android Properties sera probablement utilisé pour la configuration.

## Ce qui reste à démontrer

Nous n'avons pas encore identifié :

- toutes les propriétés ;
- le service Binder ;
- la bibliothèque native principale ;
- le pipeline graphique exact.

Ces éléments seront ajoutés au fur et à mesure de l'avancement du projet.

---

# Méthode de documentation

Chaque propriété découverte fera l'objet d'une fiche complète.

Exemple :

| Champ                  | Contenu                         |
| ---------------------- | ------------------------------- |
| Nom                    | persist.xxx                     |
| Valeur                 | observée                        |
| Source                 | getprop                         |
| Composant lecteur      | APK                             |
| Composant modificateur | Service                         |
| Impact                 | Fonctionnel                     |
| Confiance              | Confirmé / Probable / Hypothèse |

Cette approche permettra de construire progressivement une base de connaissances exploitable.

---

# Conclusion

Le système Keystone constitue l'une des fonctions les plus complexes du HY300.

Il mobilise des composants répartis entre Android, les bibliothèques natives et le matériel.

Ce chapitre établit les bases de cette architecture.

Les chapitres suivants permettront de comprendre comment les mises à jour, les services OEM et le moteur graphique interagissent avec cette fonctionnalité.

---

> [!IMPORTANT]
> Les propriétés Android ne doivent pas être interprétées isolément. Une propriété n'est qu'un état ou un paramètre. Pour comprendre son rôle, il est indispensable d'identifier quel composant la lit, qui la modifie et à quel moment elle intervient dans le fonctionnement du système.

---

# Chapitre suivant

➡️ **29 – Keystone Update Pulse : mécanismes de mise à jour, synchronisation et surveillance**