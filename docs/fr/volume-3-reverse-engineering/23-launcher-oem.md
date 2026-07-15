---
title: "Launcher OEM : Reverse Engineering complet"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 23 — Launcher OEM

> *« Le Launcher n'est pas Android. Il est simplement l'application qui donne à Android son apparence. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre l'architecture complète du Launcher OEM ;
- identifier les interactions entre le Launcher et Android ;
- comprendre comment le constructeur personnalise l'expérience utilisateur ;
- préparer les modifications futures du firmware Ultimate.

---

# Introduction

Lorsqu'un utilisateur allume le HY300, la première chose qu'il voit est le Launcher.

Pour beaucoup d'utilisateurs, il représente le système d'exploitation.

En réalité, il ne s'agit que d'une application Android.

Une application particulière.

Très privilégiée.

Mais une application malgré tout.

Cette distinction est essentielle.

Le Launcher peut être remplacé.

Android continue pourtant à fonctionner.

---

# Le rôle du Launcher

Le Launcher possède plusieurs responsabilités.

Il affiche :

- l'écran d'accueil ;
- les raccourcis ;
- les applications ;
- les entrées HDMI ;
- les réglages rapides ;
- parfois les recommandations.

Il ne pilote cependant pas directement le matériel.

Toutes les fonctions avancées transitent par :

- Android Framework ;
- Binder ;
- Services OEM.

---

# Position dans l'architecture

```text
Utilisateur

↓

Launcher OEM

↓

Framework Android

↓

Binder IPC

↓

Services OEM

↓

HAL

↓

Drivers

↓

RK3326
```

Le Launcher ne dialogue jamais directement avec le matériel.

---

# Identification

Première étape :

identifier le package.

Commandes utilisées :

```bash
pm list packages

pm list packages -f

dumpsys package
```

Les informations suivantes devront être documentées.

- nom du package ;
- version ;
- UID ;
- partition d'origine ;
- signature.

---

# Décompilation

Les outils utilisés seront :

```text
apktool

jadx

aapt2

apkanalyzer
```

Chaque extraction sera archivée dans :

```
assets/reverse-engineering/launcher/
```

---

# Analyse du manifeste

Le manifeste constitue la première source d'information.

Nous documenterons :

## Activities

Quelle activité est déclarée :

```xml
MAIN

HOME
```

C'est cette activité qui devient le Launcher Android.

---

## Permissions

Nous rechercherons notamment :

```text
SYSTEM_ALERT_WINDOW

WRITE_SECURE_SETTINGS

PACKAGE_USAGE_STATS

RECEIVE_BOOT_COMPLETED
```

Ces permissions donnent une idée des privilèges du Launcher.

---

## Services

Plusieurs services internes pourront être présents.

Ils seront documentés individuellement.

---

## Broadcast Receivers

Le Launcher reçoit généralement :

- démarrage Android ;
- insertion USB ;
- changement réseau ;
- installation d'application.

Tous ces événements seront cartographiés.

---

# Architecture logicielle

Après décompilation,

nous établirons une carte complète.

```text
LauncherActivity

↓

Fragments

↓

Adapters

↓

Services

↓

JNI

↓

Binder
```

Cette représentation facilitera énormément la compréhension du code.

---

# Analyse des ressources

Le dossier :

```
res/
```

contient :

- icônes ;
- images ;
- couleurs ;
- animations ;
- thèmes.

Le constructeur personnalise généralement fortement cette partie.

Nous documenterons :

- résolution ;
- formats ;
- organisation.

---

# Navigation

Une attention particulière sera portée :

- au menu principal ;
- aux paramètres ;
- aux entrées HDMI ;
- au navigateur de fichiers ;
- au lecteur multimédia.

Chaque écran sera relié :

- aux classes Java ;
- aux layouts XML.

---

# Recherche des appels Binder

Le Launcher délègue de nombreuses opérations.

Nous rechercherons :

- ServiceManager
- IBinder
- AIDL
- transact()

Ces appels permettront de comprendre :

comment le Launcher communique avec les services système.

---

# JNI

Le constructeur utilise parfois :

```
System.loadLibrary()
```

Nous rechercherons :

- toutes les bibliothèques natives ;
- les appels JNI ;
- les méthodes natives.

Ces informations seront rapprochées du chapitre consacré à :

```
librkgfx

ProjectUtils

Bridge
```

---

# Communication avec Keystone

Le Launcher semble interagir avec :

- autofocus ;
- correction trapézoïdale ;
- paramètres d'affichage.

Nous rechercherons :

```java
getprop

setprop

persist.keystone.*

Intent

Binder
```

L'objectif sera de déterminer comment l'interface utilisateur pilote ces fonctions.

---

# Communication avec QuickShare

Même principe.

Nous documenterons :

- lancement ;
- arrêt ;
- intents ;
- callbacks.

---

# Performances

Le Launcher sera également étudié sous l'angle des performances.

Nous mesurerons notamment :

- temps de démarrage ;
- mémoire consommée ;
- services créés ;
- threads.

Les outils utilisés seront :

```bash
dumpsys meminfo

dumpsys gfxinfo

top

ps
```

---

# Analyse de sécurité

Les questions suivantes guideront cette partie.

## Les activités sont-elles exportées ?

Une activité exportée peut parfois être appelée par une application tierce.

Nous vérifierons systématiquement cette propriété.

---

## Les permissions sont-elles justifiées ?

Chaque permission privilégiée sera documentée.

L'objectif est de distinguer :

- les permissions nécessaires ;
- les permissions potentiellement excessives.

---

## Le Launcher exécute-t-il des commandes système ?

Nous rechercherons :

```java
Runtime.exec()

ProcessBuilder

su

reboot

setprop
```

Ces appels peuvent révéler des fonctions d'administration.

---

# Ce que nous savons déjà

## Faits

- Le Launcher est une application OEM.
- Il constitue l'interface principale du HY300.
- Il s'appuie sur les services Android standards.

## Ce qu'il reste à confirmer

- son architecture interne ;
- ses interactions Binder ;
- ses bibliothèques natives ;
- ses communications avec Keystone ;
- ses optimisations spécifiques.

Ces éléments seront établis lors de l'analyse statique et dynamique.

---

# Travaux futurs

Les étapes suivantes consisteront à :

- décompiler complètement l'APK ;
- cartographier les classes ;
- documenter toutes les activités ;
- identifier les bibliothèques JNI ;
- observer les échanges Binder ;
- mesurer les performances.

Les résultats viendront compléter ce chapitre.

---

# Conclusion

Le Launcher constitue la couche visible du firmware.

Il ne représente pourtant qu'une petite partie de l'architecture globale.

L'analyse détaillée de son code permettra de comprendre comment le constructeur relie l'interface utilisateur aux services propriétaires qui contrôlent réellement le projecteur.

---

> [!IMPORTANT]
> Le Launcher n'est généralement pas responsable des fonctions matérielles (autofocus, correction trapézoïdale, projection). Il agit principalement comme une interface graphique qui délègue ces opérations à d'autres services du système. Cette distinction sera essentielle pour comprendre l'organisation du firmware.

---

# Chapitre suivant

➡️ **24 – QuickShare et USBDisplay : Reverse Engineering des fonctions de projection**