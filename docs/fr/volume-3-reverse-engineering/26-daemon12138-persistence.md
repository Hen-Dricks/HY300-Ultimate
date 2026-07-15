---
title: "Daemon12138 : mécanismes de lancement et de persistance"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 26 — Daemon12138 : mécanismes de lancement et de persistance

> *« Comprendre un démon ne consiste pas uniquement à identifier son exécutable. Il faut également comprendre comment il apparaît, pourquoi il reste actif et dans quelles conditions il est relancé. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- reconstituer le cycle de vie complet d'un démon Android ;
- identifier les différents mécanismes de persistance utilisés par Android ;
- comprendre comment rechercher l'origine d'un processus ;
- reproduire cette méthodologie sur un autre appareil Android.

---

# Introduction

Découvrir un processus inconnu constitue seulement la première étape.

Pour comprendre réellement son rôle, il est indispensable de répondre à plusieurs questions fondamentales :

- Qui le lance ?
- À quel moment est-il lancé ?
- Est-il lancé une seule fois ?
- Est-il relancé automatiquement ?
- Dépend-il d'une propriété système ?
- Peut-il être arrêté sans conséquence ?

Ces questions sont essentielles pour distinguer un simple service d'un composant critique du système.

---

# Définition de la persistance

Dans le contexte Android, un processus est considéré comme persistant lorsqu'il peut être recréé automatiquement après sa terminaison.

Cette persistance peut être assurée par plusieurs mécanismes :

- `init`
- un watchdog
- une application système
- un service Binder
- un script shell
- une propriété Android

L'objectif de cette étude est d'identifier lequel est utilisé dans le cas de Daemon12138.

---

# Les mécanismes de lancement possibles

Avant toute analyse, il est utile de rappeler les principales méthodes employées par Android pour lancer un démon.

## Service `init`

Le cas le plus fréquent.

Le service est déclaré dans un fichier `.rc`.

Exemple :

```rc
service exampled /system/bin/exampled
    class main
    user root
```

---

## Déclenchement par une propriété

Un service peut être lancé lorsqu'une propriété change.

Exemple :

```rc
on property:sys.boot_completed=1
    start exampled
```

---

## Lancement par une application

Une application système peut démarrer un service via :

- `startService()`
- Binder
- `Runtime.exec()`

---

## Watchdog

Certains constructeurs utilisent un second démon chargé de surveiller un premier processus.

Si celui-ci disparaît, il est immédiatement relancé.

---

# Méthodologie retenue

Notre démarche consiste à éliminer progressivement chaque possibilité.

Pour cela, plusieurs recherches sont effectuées.

---

# Recherche dans les scripts init

Première étape :

```bash
grep -R "Daemon12138" /vendor/etc/init

grep -R "Daemon12138" /system/etc/init

grep -R "Daemon12138" /
```

Cette recherche permet de déterminer si le démon est déclaré comme un service `init`.

---

# Recherche dans les propriétés

Deuxième étape :

```bash
getprop

grep daemon

grep 12138
```

Nous recherchons :

- une propriété dédiée ;
- un déclencheur ;
- un état interne.

---

# Recherche dans les APK

Un démon peut être lancé par une application.

Nous rechercherons donc :

```bash
jadx

↓

Recherche :

Runtime.exec

ProcessBuilder

startService

startForegroundService
```

L'objectif est d'identifier un éventuel lancement logiciel.

---

# Recherche dans les scripts shell

Les constructeurs utilisent parfois des scripts de démarrage.

Nous rechercherons :

```bash
grep -R "Daemon12138" /vendor/bin

grep -R "Daemon12138" /system/bin

grep -R "Daemon12138" /system/etc
```

---

# Analyse des processus

Une fois le démon identifié, plusieurs informations devront être collectées.

Exemple :

```bash
ps -A

pidof Daemon12138
```

Puis :

```bash
cat /proc/<PID>/status
```

Ces données permettront d'établir :

- l'utilisateur ;
- le groupe ;
- le parent ;
- les capacités Linux.

---

# Recherche des dépendances

Le démon peut dépendre :

- d'une bibliothèque ;
- d'un socket ;
- d'un périphérique.

Nous rechercherons :

```bash
cat /proc/<PID>/maps
```

afin d'identifier les bibliothèques réellement chargées.

---

# Les sockets

Autre point important.

Nous chercherons si Daemon12138 ouvre :

```bash
ss -lpn

netstat -tulpn
```

Selon les résultats, plusieurs cas sont possibles.

## Socket Unix

Communication locale.

---

## Socket TCP

Communication réseau.

---

## Binder

Communication interne Android.

---

# Les journaux

Le comportement du démon sera également observé via :

```bash
logcat

dmesg
```

Nous rechercherons notamment :

- erreurs ;
- démarrage ;
- arrêt ;
- redémarrage.

---

# Reconstruction du cycle de vie

À terme, nous établirons un diagramme complet.

```text
BootROM

↓

Linux

↓

init

↓

Service RC

↓

Daemon12138

↓

Sockets

↓

Applications

↓

Fonctions OEM
```

Ce diagramme sera complété au fur et à mesure de l'avancement des analyses.

---

# Ce que nous savons actuellement

## Faits

Nous avons identifié :

- un composant nommé Daemon12138 ;
- sa présence dans le firmware.

À ce stade, aucune preuve ne permet encore d'affirmer :

- comment il est lancé ;
- qui le lance ;
- comment il est maintenu actif.

---

# Ce que nous cherchons à démontrer

Cette étude devra répondre à plusieurs questions.

- Est-il déclaré dans un fichier `init.rc` ?
- Dépend-il d'une propriété Android ?
- Est-il lancé par une application ?
- Est-il surveillé par un autre processus ?
- Possède-t-il un watchdog ?

Aucune réponse ne sera considérée comme acquise avant validation expérimentale.

---

# Pourquoi cette analyse est importante

Les mécanismes de persistance sont essentiels pour comprendre l'architecture d'un firmware.

Ils permettent notamment :

- d'identifier les composants critiques ;
- de comprendre les dépendances ;
- d'évaluer l'impact d'une désactivation éventuelle ;
- de préparer des modifications du firmware sans perturber son fonctionnement.

---

# Conclusion

La découverte de Daemon12138 ne constitue que le point de départ.

Comprendre sa persistance est indispensable pour déterminer son importance réelle au sein du système.

Cette approche méthodique permettra d'éviter toute conclusion hâtive et de produire une documentation fondée sur des observations reproductibles.

---

> [!IMPORTANT]
> À ce stade de l'étude, aucune hypothèse concernant la persistance de Daemon12138 n'est retenue comme un fait. Les mécanismes décrits dans ce chapitre correspondent aux différentes possibilités offertes par Android et devront être confirmés par l'analyse des fichiers système et des observations en fonctionnement.

---

# Chapitre suivant

➡️ **27 – Daemon12138 : analyse de sécurité et évaluation des risques**