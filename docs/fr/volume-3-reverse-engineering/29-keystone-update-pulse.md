---
title: "Keystone Update Pulse : synchronisation et orchestration"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 29 — Keystone Update Pulse : synchronisation et orchestration

> *« Corriger une image n'est pas un événement unique. C'est une succession de décisions prises en temps réel en fonction de l'état du système et des interactions de l'utilisateur. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre comment une correction trapézoïdale peut être synchronisée avec le reste du système ;
- identifier les mécanismes Android permettant de propager des changements d'état ;
- mettre en place une méthodologie pour analyser les composants responsables de cette synchronisation.

---

# Introduction

Lorsqu'un utilisateur active ou modifie une correction trapézoïdale, plusieurs composants doivent être informés.

Par exemple :

- l'interface utilisateur ;
- le moteur graphique ;
- le service Keystone ;
- le système d'affichage.

Ces composants doivent rester synchronisés.

Le constructeur peut utiliser différents mécanismes pour assurer cette coordination.

Notre objectif est de déterminer lequel est utilisé sur le HY300.

---

# Pourquoi parler de "Pulse" ?

Dans certains firmwares Android embarqués, des composants assurent un rôle de surveillance continue ou de synchronisation.

Ils peuvent :

- détecter un changement de propriété ;
- observer un état matériel ;
- notifier plusieurs services ;
- déclencher un recalcul.

Le terme *Pulse* est utilisé ici comme une description fonctionnelle de cette phase de synchronisation. Il ne préjuge pas du nom réel du composant utilisé dans le firmware.

---

# Architecture fonctionnelle

Une architecture typique peut être représentée ainsi :

```text
Utilisateur

↓

Launcher

↓

Modification d'un paramètre

↓

Service Keystone

↓

Mise à jour des propriétés système

↓

Notification

↓

Moteur graphique

↓

Nouvelle image affichée
```

Le firmware du HY300 sera étudié afin d'identifier les composants effectivement impliqués.

---

# Les mécanismes Android susceptibles d'être utilisés

Android propose plusieurs moyens de synchroniser des composants.

## Android Properties

Une propriété peut être modifiée :

```bash
setprop
```

et consultée :

```bash
getprop
```

Les composants intéressés peuvent alors adapter leur comportement.

---

## Binder

Les services Android communiquent souvent via Binder.

Nous rechercherons :

- interfaces AIDL ;
- transactions ;
- services enregistrés.

---

## Broadcast

Une application peut diffuser un événement.

Exemple :

```java
sendBroadcast()
```

Les composants abonnés reçoivent immédiatement la notification.

---

## Callback

Un service peut directement notifier un client via une interface.

Cette méthode est très fréquente dans les applications OEM.

---

# Méthodologie

Les recherches porteront sur :

```bash
getprop

logcat

dumpsys

service list
```

ainsi que sur les APK et les bibliothèques natives.

---

# Analyse des journaux

Pendant les essais, nous observerons notamment :

- activation de Keystone ;
- désactivation ;
- correction automatique ;
- correction manuelle.

Les journaux permettront de corréler :

- les actions utilisateur ;
- les changements de propriétés ;
- les services déclenchés.

---

# Recherche des composants impliqués

Les recherches porteront sur les mots-clés :

```
keystone

update

notify

listener

callback

observer

pulse

geometry
```

Les composants découverts seront documentés individuellement.

---

# Binder

Nous chercherons à répondre aux questions suivantes :

- quels services Binder participent à la correction ?
- quelles méthodes sont invoquées ?
- quelles données sont échangées ?

---

# Les propriétés

Chaque propriété observée sera intégrée dans la base de connaissances du projet.

Exemple de fiche :

| Champ               | Valeur              |
| ------------------- | ------------------- |
| Nom                 | persist.xxx         |
| Valeur              | observée            |
| Source              | getprop             |
| Lecteur             | service identifié   |
| Modificateur        | composant identifié |
| Niveau de confiance | confirmé / probable |

---

# Synchronisation avec le moteur graphique

Une correction trapézoïdale n'a d'effet que lorsqu'elle atteint le pipeline graphique.

Nous chercherons donc à identifier :

- les appels JNI ;
- les bibliothèques natives ;
- les interactions avec SurfaceFlinger.

Cette partie fera le lien avec le chapitre suivant.

---

# Ce que nous savons

## Confirmé

- le HY300 dispose d'une correction trapézoïdale ;
- plusieurs composants OEM participent à cette fonctionnalité.

## À confirmer

Nous n'avons pas encore démontré :

- quel composant orchestre la synchronisation ;
- si un service dédié existe ;
- si la synchronisation repose sur Binder, les propriétés Android, des callbacks ou une combinaison de ces mécanismes.

---

# Limites de l'analyse

À ce stade, aucune preuve ne permet d'affirmer l'existence d'un composant nommé "Keystone Update Pulse" dans le firmware.

Ce chapitre décrit les mécanismes susceptibles d'être impliqués et la méthodologie employée pour les identifier.

Les résultats seront complétés au fur et à mesure de l'avancement des analyses.

---

# Conclusion

Comprendre Keystone ne consiste pas uniquement à identifier un algorithme de correction géométrique.

Il faut également comprendre comment les différents composants du système restent synchronisés lorsque l'état du projecteur évolue.

Cette orchestration constitue un élément essentiel de l'expérience utilisateur.

---

> [!IMPORTANT]
> Toute conclusion sur les mécanismes de synchronisation devra être fondée sur des observations expérimentales (logs, Binder, propriétés, captures d'exécution). En l'absence de telles observations, plusieurs architectures restent possibles.

---

# Chapitre suivant

➡️ **30 – SurfaceFlinger et librkgfx : comprendre le pipeline graphique du HY300**