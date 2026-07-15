---
title: "SurfaceFlinger et librkgfx : Anatomie complète du pipeline graphique"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 30 — SurfaceFlinger et librkgfx

> *« L'utilisateur touche un bouton. Quelques millisecondes plus tard, des millions de pixels changent d'état. Entre ces deux événements, Android exécute l'un des pipelines graphiques les plus sophistiqués de son architecture. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre comment Android dessine une image ;
- comprendre le rôle de SurfaceFlinger ;
- comprendre comment Rockchip accélère l'affichage ;
- comprendre où intervient Keystone ;
- comprendre où rechercher les optimisations graphiques du constructeur.

---

# Introduction

Lorsqu'une application Android dessine un bouton, une vidéo ou une image, elle ne communique jamais directement avec l'écran.

Plusieurs dizaines de composants interviennent successivement.

Le HY300 ne fait pas exception.

Au contraire.

Son pipeline graphique est encore plus complexe puisqu'il doit également :

- appliquer la correction trapézoïdale ;
- piloter le moteur de projection ;
- maintenir une cadence vidéo stable.

Comprendre cette chaîne est indispensable avant toute optimisation graphique.

---

# Vue d'ensemble

Le pipeline peut être représenté ainsi.

```text
Application

↓

View

↓

Canvas / OpenGL ES / Vulkan

↓

Surface

↓

BufferQueue

↓

SurfaceFlinger

↓

Hardware Composer

↓

Rockchip Graphics Stack

↓

GPU

↓

Contrôleur vidéo

↓

Projecteur
```

Chaque étape possède un rôle précis.

---

# Les applications

Toutes les applications Android dessinent leur interface.

Cependant,

elles ne dessinent jamais directement à l'écran.

Elles dessinent dans :

```
Surface
```

Cette surface correspond à une mémoire tampon.

---

# BufferQueue

Android utilise :

```
BufferQueue
```

comme mécanisme d'échange.

Le principe est simple.

```
Application

↓

Produit un buffer

↓

SurfaceFlinger

↓

Consomme le buffer
```

Ce découplage permet :

- un affichage fluide ;
- un découplage entre CPU et GPU ;
- une meilleure stabilité.

---

# SurfaceFlinger

SurfaceFlinger est le compositeur graphique officiel d'Android.

Il reçoit toutes les surfaces.

Puis il décide :

- de leur ordre ;
- de leur transparence ;
- de leur position ;
- de leur transformation.

Toutes les applications visibles passent par lui.

---

# Les responsabilités de SurfaceFlinger

Il est chargé notamment de :

- composer les fenêtres ;
- synchroniser le rendu ;
- gérer les buffers ;
- communiquer avec Hardware Composer.

Il constitue donc l'un des composants les plus importants d'Android.

---

# Hardware Composer

SurfaceFlinger ne pilote pas directement le GPU.

Il délègue certaines opérations au :

```
Hardware Composer

(HWC)
```

Celui-ci choisit :

- quelles couches seront dessinées par le GPU ;
- lesquelles seront directement composées par le matériel.

Cette approche améliore considérablement les performances.

---

# Rockchip Graphics

Le HY300 utilise une plateforme Rockchip.

Nous rechercherons notamment les composants suivants.

```
librkgfx.so

libhwcomposer.so

libgralloc.so

libEGL.so

libGLESv2.so
```

Tous ces éléments participent au rendu graphique.

Leur présence exacte dépendra du firmware extrait.

---

# librkgfx

Le nom :

```
librkgfx
```

suggère une bibliothèque graphique spécifique à Rockchip.

À ce stade :

## Confirmé

Nous avons identifié sa présence dans le firmware.

## Non démontré

Nous n'avons pas encore documenté :

- toutes ses fonctions ;
- ses exports ;
- son interface JNI ;
- son rôle exact.

Ces points seront étudiés par reverse engineering.

---

# Keystone

Une correction trapézoïdale implique :

- une transformation géométrique ;
- une recomposition de l'image.

Cette opération intervient probablement entre :

```
SurfaceFlinger

↓

GPU

↓

Affichage
```

L'emplacement exact reste à confirmer.

---

# OpenGL ES

Les applications Android utilisent généralement :

```
OpenGL ES
```

pour dessiner.

Le pipeline devient alors :

```
Application

↓

OpenGL ES

↓

EGL

↓

GPU

↓

Buffer

↓

SurfaceFlinger
```

---

# Synchronisation

Le rendu est synchronisé grâce au :

```
VSYNC
```

Chaque image est affichée :

```
60 Hz

↓

16,67 ms
```

ou selon la fréquence retenue par le firmware.

---

# GPU

Le GPU reçoit :

- textures ;
- vertices ;
- shaders.

Puis il calcule :

- les pixels ;
- les transformations ;
- les effets.

Le projecteur affiche ensuite le résultat.

---

# Où intervient Keystone ?

C'est l'une des questions majeures du projet.

Plusieurs architectures sont possibles.

## Cas 1

Transformation dans SurfaceFlinger.

---

## Cas 2

Transformation dans Hardware Composer.

---

## Cas 3

Transformation dans une bibliothèque native.

---

## Cas 4

Transformation directement dans le GPU.

À ce stade,

aucune de ces hypothèses n'a été confirmée.

---

# Méthodologie

Nous utiliserons :

```bash
dumpsys SurfaceFlinger

dumpsys display

dumpsys gfxinfo

logcat
```

Nous rechercherons également :

```
libsurfaceflinger

librkgfx

gralloc

composer
```

dans les bibliothèques natives.

---

# Performances

Les indicateurs suivants seront mesurés.

- FPS
- Frame Time
- Jank
- Buffers
- Mémoire graphique

Ces données permettront de comparer :

Firmware constructeur

↓

HY300 Ultimate

---

# Ce que nous avons réellement observé

## Confirmé

- SurfaceFlinger est présent (composant standard Android).
- Le firmware utilise une pile graphique Rockchip.
- Des bibliothèques spécifiques au constructeur sont présentes.

## À confirmer

Nous n'avons pas encore démontré :

- le rôle exact de `librkgfx` ;
- le point d'application de Keystone ;
- la répartition des traitements entre CPU, GPU et Hardware Composer.

Ces éléments seront établis par analyse des bibliothèques et des traces d'exécution.

---

# Travaux futurs

Les prochaines étapes incluront :

- extraction des bibliothèques graphiques ;
- analyse ELF (`readelf`, `nm`, `objdump`) ;
- recherche des symboles liés à Keystone ;
- observation du pipeline avec `dumpsys SurfaceFlinger`.

---

# Conclusion

Le pipeline graphique du HY300 repose sur les fondations standard d'Android, enrichies par des composants spécifiques à Rockchip et au constructeur.

Comprendre cette chaîne est indispensable pour toute optimisation des performances ou toute modification des fonctions de projection.

Ce chapitre constitue une base méthodologique qui sera enrichie au fur et à mesure des analyses expérimentales.

---

> [!IMPORTANT]
> Les transformations graphiques observées sur un appareil Android ne sont pas nécessairement réalisées par un seul composant. Selon les choix du constructeur, elles peuvent être réparties entre SurfaceFlinger, Hardware Composer, des bibliothèques natives ou directement le GPU. Toute attribution devra être confirmée par des preuves techniques.

---

# Chapitre suivant

➡️ **31 – ProjectUtils et Bridge : les bibliothèques de liaison entre Android et le matériel**