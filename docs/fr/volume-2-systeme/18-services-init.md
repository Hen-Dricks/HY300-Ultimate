---
title: "Init : naissance du système Android"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 18 — Init : naissance du système Android

> *« Android ne démarre pas grâce au Launcher. Il démarre grâce à un unique processus qui crée progressivement tout le système. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre le rôle de `init` ;
- expliquer pourquoi il possède toujours le PID 1 ;
- comprendre le fonctionnement des fichiers `.rc` ;
- analyser un service Android ;
- comprendre comment le constructeur ajoute ses propres services ;
- interpréter les fichiers `vendor_flash_recovery.rc`, `bootanim.rc` et `recovery-persist.rc`.

---

# Introduction

Lorsque Linux termine son initialisation, le noyau ne lance pas Android.

Il lance un seul programme.

```
init
```

Tout Android sera construit progressivement par ce processus.

Si `init` s'arrête,

Android disparaît immédiatement.

Aucun autre processus n'a autant d'importance.

---

# Le PID 1

Sous Linux,

chaque processus possède un identifiant.

```
PID
```

Le premier processus utilisateur est toujours :

```
PID = 1
```

Sur Android :

```
init
```

est ce processus.

Tous les autres processus du système descendent directement ou indirectement de lui.

```
Linux

↓

init (PID 1)

↓

zygote

↓

system_server

↓

Applications
```

---

# Pourquoi init existe-t-il ?

Le noyau Linux ne connaît rien d'Android.

Il sait :

- gérer la mémoire ;
- gérer les processus ;
- gérer les périphériques.

Mais il ignore complètement :

- ActivityManager ;
- SurfaceFlinger ;
- PackageManager ;
- Launcher.

Il faut donc un programme chargé de construire progressivement Android.

C'est exactement le rôle de `init`.

---

# Les responsabilités de init

Au démarrage, `init` :

- monte les partitions ;
- crée les répertoires système ;
- initialise les propriétés Android ;
- configure SELinux ;
- lance les services ;
- déclenche les événements de démarrage ;
- surveille les processus critiques.

Il ne quitte pratiquement jamais la mémoire.

---

# Les fichiers `.rc`

Le comportement de `init` est décrit dans plusieurs fichiers texte.

Exemples :

```
init.rc

vendor.rc

ueventd.rc

bootanim.rc

vendor_flash_recovery.rc

recovery-persist.rc
```

Chaque fichier décrit :

- des actions ;
- des événements ;
- des services.

---

# Structure d'un fichier RC

Un fichier `rc` ressemble généralement à ceci :

```rc
service media /system/bin/mediaserver
    class main
    user media
    group audio camera
```

Chaque bloc définit un service.

---

# Les événements

Android fonctionne principalement avec des déclencheurs.

Par exemple :

```
on boot
```

signifie :

```
Lorsque Android démarre...
```

On peut également trouver :

```
on property
```

qui signifie :

```
Lorsque cette propriété change...
```

Cette architecture évite de lancer inutilement des services.

---

# Les classes

Les services sont regroupés dans des classes.

Par exemple :

```
class core
```

ou

```
class main
```

Android peut ainsi démarrer ou arrêter plusieurs services simultanément.

---

# Les services

Prenons un exemple réel observé pendant notre enquête.

Nous avons extrait :

```
/vendor/etc/init/vendor_flash_recovery.rc
```

Son contenu est :

```rc
service vendor_flash_recovery /vendor/bin/install-recovery.sh
    class main
    oneshot
```

---

# Analyse ligne par ligne

## service

Déclare un nouveau service.

Son nom est :

```
vendor_flash_recovery
```

---

## /vendor/bin/install-recovery.sh

Le programme exécuté.

Dans notre cas :

un simple script shell.

---

## class main

Le service appartient à :

```
main
```

Il sera donc lancé avec les autres services principaux du système.

---

## oneshot

Cette option est extrêmement importante.

Elle signifie :

```
Exécuter une seule fois.

Ne jamais redémarrer automatiquement.
```

Autrement dit :

le script vérifie Recovery,

effectue éventuellement une réparation,

puis disparaît.

---

# Pourquoi ce choix ?

Si ce service était relancé en permanence,

il vérifierait continuellement la partition Recovery.

Cela serait inutile.

Le constructeur a donc choisi :

```
oneshot
```

qui est parfaitement adapté.

---

# Le script associé

Le service appelle :

```
install-recovery.sh
```

Nous avons analysé son contenu.

Il effectue :

```
applypatch --check
```

puis éventuellement :

```
applypatch

↓

recovery-from-boot.p

↓

recovery
```

Le constructeur a donc intégré directement cette logique au système de démarrage.

---

# Boot Animation

Nous avons également identifié :

```
bootanim.rc
```

Ce fichier est chargé de lancer :

```
bootanimation
```

Le principe est simple.

Pendant qu'Android continue de démarrer,

une animation est affichée.

L'utilisateur perçoit ainsi un système réactif,

alors qu'en réalité plusieurs centaines de processus sont encore en cours de création.

---

# Recovery Persist

Autre fichier observé :

```
recovery-persist.rc
```

Son objectif est de lancer :

```
recovery-persist
```

Ce composant intervient notamment après certains démarrages Recovery afin de conserver ou recopier des informations utiles.

Le comportement exact dépend du constructeur et des fonctionnalités activées.

Dans notre étude, nous avons confirmé sa présence, sans modifier son fonctionnement.

---

# Les propriétés Android

`init` est également responsable des propriétés système.

Par exemple :

```
ro.*

persist.*

sys.*
```

Ces propriétés sont utilisées partout.

Exemple :

```
getprop
```

lit directement les données gérées par `init`.

Dans les volumes suivants,

nous consacrerons un chapitre entier à leur analyse.

---

# Les dépendances

Un service peut dépendre :

- d'une propriété ;
- d'une partition ;
- d'un autre service.

Ainsi,

Android construit progressivement le système.

```
Partitions

↓

init

↓

Properties

↓

Services

↓

Framework

↓

Launcher
```

---

# Ce que nous avons réellement observé

Pendant notre étude,

nous avons confirmé la présence de plusieurs fichiers importants :

```
vendor_flash_recovery.rc

bootanim.rc

recovery-persist.rc
```

Tous sont référencés dans :

```
/vendor/etc/init
```

Ils montrent que le constructeur utilise directement le mécanisme officiel de `init` pour intégrer ses fonctionnalités.

Aucun système propriétaire parallèle n'a été identifié pour cette partie du démarrage.

---

# Pourquoi c'est important

Cette observation a une conséquence importante.

Les fonctionnalités spécifiques au HY300 sont majoritairement intégrées **dans l'architecture standard d'Android**, et non à travers un mécanisme de démarrage entièrement propriétaire.

Cela facilite :

- leur compréhension ;
- leur documentation ;
- leur modification éventuelle.

---

# Résumé

`init` constitue le véritable chef d'orchestre d'Android.

Il :

- monte les partitions ;
- crée les propriétés ;
- lance les services ;
- déclenche les scripts constructeur ;
- construit progressivement le système.

Sans lui,

Android n'existerait tout simplement pas.

---

> [!IMPORTANT]
> Lorsqu'un appareil Android semble « bloqué au démarrage », le problème ne provient pas nécessairement du noyau Linux. Dans de nombreux cas, il s'agit d'un service lancé par `init` qui échoue, d'une partition qui ne peut pas être montée ou d'une propriété système qui n'est jamais définie. Comprendre le rôle de `init` est donc essentiel pour diagnostiquer ce type de panne.

---

# Conclusion

L'étude des services `init` marque la fin de notre exploration des fondations du système Android.

Nous avons désormais une vision complète de la manière dont le HY300 passe :

1. du BootROM au noyau Linux ;
2. du noyau au processus `init` ;
3. d'`init` aux services Android ;
4. des services au Framework ;
5. du Framework au Launcher constructeur.

Cette compréhension constitue la base indispensable pour les volumes suivants, consacrés au reverse engineering des applications OEM, des bibliothèques natives et des mécanismes spécifiques au projecteur.

---

## Chapitre suivant

➡️ **19 – Conclusions du Volume II**