---
title: "Chaîne de démarrage Rockchip"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 11 — La chaîne de démarrage Rockchip

> *« Un système Android ne démarre jamais directement. Avant qu'Android n'existe, une succession de programmes prépare minutieusement le terrain. »*

---

# Objectifs du chapitre

À la fin de ce chapitre, le lecteur comprendra :

- le fonctionnement complet du démarrage d'un SoC Rockchip ;
- le rôle exact de chaque partition de boot ;
- pourquoi BootROM est immuable ;
- comment U-Boot prépare Android ;
- où intervient Linux ;
- comment Android prend progressivement le contrôle de la machine.

---

# Introduction

Lorsqu'un utilisateur appuie sur le bouton **Power**, il a souvent l'impression qu'Android démarre immédiatement.

En réalité, Android est le **dernier maillon** d'une longue chaîne.

Avant lui, plusieurs programmes spécialisés se succèdent.

Chacun possède une responsabilité très précise.

Chaque programme prépare l'environnement nécessaire au suivant.

Si une seule étape échoue, le système entier s'arrête.

Pour comprendre un firmware Android, il est donc indispensable de comprendre cette chronologie.

---

# Vue d'ensemble

Le démarrage du HY300 peut être représenté de la manière suivante.

```text
                    Mise sous tension
                           │
                           ▼
                  BootROM (RK3326)
                           │
                           ▼
                     MiniLoader
                           │
                           ▼
                     Trust Firmware
                           │
                           ▼
                        U-Boot
                           │
                           ▼
                     boot.img
                           │
                           ▼
                     Linux Kernel
                           │
                           ▼
                       init (PID 1)
                           │
                           ▼
                 First Stage Mount
                           │
                           ▼
                     Dynamic Partitions
                           │
                           ▼
                    Zygote + SystemServer
                           │
                           ▼
                  Launcher constructeur
```

Ce diagramme servira de référence pendant toute la suite de l'ouvrage.

---

# Étape 1 — Mise sous tension

Tout commence lorsque le circuit de gestion de l'alimentation (PMIC) alimente progressivement les différents composants électroniques.

Le processeur sort alors de son état de veille.

À cet instant :

- aucune mémoire n'est initialisée ;
- aucun système de fichiers n'est monté ;
- Android n'existe pas encore.

Le CPU lit simplement son premier programme.

---

# Étape 2 — BootROM

Le premier logiciel exécuté est appelé **BootROM**.

Il est directement gravé dans le silicium du RK3326.

Cette mémoire est en lecture seule.

Elle ne peut être modifiée ni par Android, ni par une mise à jour OTA.

Son rôle est volontairement limité.

Il doit :

- initialiser les registres essentiels ;
- détecter le support de démarrage ;
- charger le premier chargeur.

Cette simplicité améliore énormément la fiabilité du système.

---

# Pourquoi le BootROM est important

Le BootROM représente le point de confiance initial (*Root of Trust*).

S'il est compromis, tout le reste du système devient potentiellement vulnérable.

C'est pourquoi il est intégré directement dans le SoC.

Dans le cas du RK3326, il est également responsable de l'entrée dans certains modes spéciaux comme le mode Loader utilisé par les outils Rockchip.

Cette particularité sera étudiée dans un volume ultérieur.

---

# Étape 3 — MiniLoader

Une fois le BootROM terminé, celui-ci charge un programme beaucoup plus évolué.

Chez Rockchip, il est généralement appelé :

```
MiniLoader
```

ou

```
Loader
```

Son rôle est fondamental.

Contrairement au BootROM, il connaît déjà :

- la mémoire DRAM ;
- l'eMMC ;
- certains périphériques.

Il initialise la mémoire principale afin que les programmes suivants puissent fonctionner.

Sans cette étape, Linux ne pourrait tout simplement pas être chargé.

---

# Étape 4 — Trust Firmware

Les plateformes Rockchip modernes utilisent également un composant appelé **Trust Firmware**.

Sa mission consiste principalement à fournir un environnement sécurisé destiné aux fonctions sensibles.

Selon les appareils, cette couche peut gérer :

- des fonctions cryptographiques ;
- des clés matérielles ;
- des mécanismes de vérification ;
- des appels Secure Monitor.

Le HY300 possède une partition nommée :

```
trust
```

dont nous avons confirmé l'existence lors de notre cartographie.

Cette partition sera analysée dans un chapitre dédié.

---

# Étape 5 — U-Boot

Après l'initialisation matérielle, le contrôle est transmis à **U-Boot**.

U-Boot constitue le véritable gestionnaire de démarrage.

Il décide notamment :

- quel noyau charger ;
- quel ramdisk utiliser ;
- quelles partitions doivent être montées ;
- quels paramètres transmettre au noyau Linux.

Il est également capable de lancer différents modes de démarrage.

Par exemple :

- Android normal ;
- Recovery ;
- Fastboot (lorsqu'il est implémenté).

---

# Étape 6 — Chargement de boot.img

Une fois sa configuration terminée, U-Boot charge la partition :

```
boot
```

Cette partition contient généralement :

- le noyau Linux ;
- un ramdisk ;
- la ligne de commande du noyau ;
- diverses métadonnées.

Le noyau est ensuite décompressé en mémoire.

À partir de cet instant, Linux prend progressivement le contrôle.

---

# Étape 7 — Linux

Le noyau Linux initialise alors l'ensemble du matériel.

Parmi les premières opérations :

- détection des cœurs CPU ;
- initialisation de la mémoire ;
- configuration du scheduler ;
- initialisation des pilotes ;
- création des premiers périphériques `/dev`.

Cette phase est extrêmement rapide.

Elle dure généralement quelques centaines de millisecondes.

---

# Étape 8 — Le processus init

Une fois Linux opérationnel, le premier processus utilisateur est créé.

Il possède toujours :

```
PID = 1
```

Sous Android, ce processus s'appelle :

```
init
```

Il constitue le véritable chef d'orchestre du système.

Toutes les étapes suivantes dépendront directement de lui.

---

# Étape 9 — First Stage Mount

Android 12 introduit une première phase de montage très précoce.

Cette phase lit notamment le fichier :

```
fstab.rk30board
```

que nous avons extrait pendant notre enquête.

Grâce à lui, Android sait :

- quelles partitions monter ;
- lesquelles sont logiques ;
- lesquelles appartiennent à `super.img`.

Cette étape marque la transition entre Linux et Android.

---

# Étape 10 — Les partitions dynamiques

Une fois `super.img` interprétée, Android crée progressivement :

- system
- vendor
- odm
- product
- system_ext
- vendor_dlkm
- odm_dlkm

Ces partitions deviennent alors accessibles comme des systèmes de fichiers classiques.

Cette architecture constitue l'une des principales évolutions introduites par Android récent.

---

# Étape 11 — Zygote

Le processus suivant est probablement le plus célèbre d'Android.

```
zygote
```

Son objectif est simple.

Toutes les applications Android seront créées par duplication de ce processus.

Grâce à cette technique, le lancement des applications devient extrêmement rapide.

---

# Étape 12 — System Server

Zygote lance ensuite :

```
system_server
```

Il s'agit du cœur du Framework Android.

Il héberge :

- ActivityManager
- PackageManager
- WindowManager
- DisplayManager
- PowerManager

Sans lui, Android ne possède plus aucune logique de haut niveau.

---

# Étape 13 — Les services OEM

Une fois Android opérationnel, le constructeur lance progressivement ses propres services.

C'est à cette étape que prennent vie :

- le moteur Keystone ;
- les services OTA ;
- les applications de projection ;
- les composants de maintenance ;
- les outils spécifiques au HY300.

Autrement dit :

Le projecteur ne devient réellement un projecteur qu'à partir de cette étape.

Avant cela, il s'agit essentiellement d'un système Android générique.

---

# Étape 14 — Le Launcher

Enfin, Android démarre le Launcher.

C'est la première interface visible.

Pour l'utilisateur, le système semble maintenant complètement démarré.

Pourtant, plusieurs centaines de processus ont déjà été exécutés.

---

# Ce que notre enquête confirme

Les observations réalisées sur le HY300 confirment plusieurs éléments importants.

Nous avons identifié :

- une partition `trust` ;
- une partition `boot` ;
- une partition `recovery` ;
- une partition `vbmeta` ;
- une partition `super`.

Nous avons également confirmé que le système utilise un `fstab` compatible avec le **First Stage Mount** et les **partitions dynamiques**, ce qui est cohérent avec Android 12.

Ces observations renforcent l'idée que le constructeur s'appuie largement sur l'architecture de référence proposée par Google, tout en ajoutant ses propres composants dans les couches supérieures.

---

# Résumé

Le démarrage du HY300 peut être résumé ainsi :

1. Le matériel s'initialise.
2. Le BootROM prend le contrôle.
3. Le Loader initialise la mémoire.
4. Le Trust Firmware prépare les fonctions sécurisées.
5. U-Boot choisit le mode de démarrage.
6. Linux démarre.
7. `init` construit Android.
8. Les partitions dynamiques sont montées.
9. `system_server` initialise le Framework.
10. Les services OEM sont lancés.
11. Le Launcher apparaît.

Comprendre cette chronologie est indispensable pour toute modification du firmware.

Dans le chapitre suivant, nous descendrons d'un niveau supplémentaire en cartographiant **chaque partition physique présente sur l'eMMC**, en expliquant leur rôle, leur contenu et les risques associés à leur modification.

---

> [!IMPORTANT]
> Lorsqu'un appareil ne démarre plus, identifier l'étape exacte où la chaîne de démarrage s'interrompt est souvent la clé du diagnostic. C'est pourquoi une compréhension fine de cette séquence est indispensable avant toute opération de flash ou de reverse engineering.

---

## Chapitre suivant

➡️ **12 – Cartographie complète des partitions**