---
title: "Architecture Android du HY300"
author: "HY300 Ultimate Research"
version: "1.0"
language: "fr"
status: "Draft"
last_updated: "2026-07-14"
---

# Chapitre 10 — Architecture Android

> *« Android n'est pas une application. C'est un système d'exploitation complet composé de dizaines de couches indépendantes qui coopèrent pour donner l'illusion d'un environnement unique. »*

---

# Objectifs du chapitre

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre l'architecture complète d'Android 12 ;
- identifier le rôle de chaque couche logicielle ;
- comprendre où interviennent les composants OEM ;
- situer les applications constructeur dans l'ensemble du système ;
- comprendre pourquoi certaines optimisations sont sans effet si elles sont réalisées au mauvais niveau.

Ce chapitre constitue le socle théorique du reste de cet ouvrage.

---

# Introduction

Lorsque l'on parle d'Android, beaucoup imaginent un système monolithique.

En réalité, Android est constitué d'une succession de couches indépendantes.

Chaque couche possède une responsabilité précise.

Elle ne communique avec les autres qu'au travers d'interfaces soigneusement définies.

Cette organisation est essentielle.

Elle permet à Google, aux fabricants de processeurs, aux constructeurs OEM et aux développeurs d'applications de travailler simultanément sans modifier l'intégralité du système.

Le HY300 ne fait pas exception.

Bien qu'il soit commercialisé comme un simple vidéoprojecteur, il exécute une architecture Android pratiquement complète.

Notre enquête a confirmé la présence de toutes les couches majeures attendues sur un appareil Android moderne.

---

# Vue d'ensemble

L'architecture du HY300 peut être représentée de la manière suivante.

```text
+------------------------------------------------------+
| Applications utilisateur                             |
| Netflix • YouTube • VLC • APK installées             |
+------------------------------------------------------+
| Applications OEM                                     |
| Launcher • Keystone • OTA • Projection               |
+------------------------------------------------------+
| Framework Android                                    |
| ActivityManager • WindowManager • PackageManager     |
+------------------------------------------------------+
| System Server                                        |
| Services Java du système                             |
+------------------------------------------------------+
| Binder IPC                                           |
+------------------------------------------------------+
| HAL (Hardware Abstraction Layer)                     |
+------------------------------------------------------+
| Bibliothèques natives                                |
| libc • libbinder • EGL • OpenGL • MediaCodec         |
+------------------------------------------------------+
| Linux Kernel                                         |
+------------------------------------------------------+
| Drivers Rockchip                                     |
+------------------------------------------------------+
| RK3326                                                |
+------------------------------------------------------+
```

Ce schéma servira de référence pendant toute la suite du livre.

---

# Une architecture modulaire

Contrairement à de nombreux systèmes embarqués, Android ne repose pas sur une seule application principale.

Il est constitué d'une multitude de composants spécialisés.

Chaque composant peut évoluer indépendamment.

Cette modularité explique pourquoi un constructeur peut personnaliser profondément Android sans modifier son cœur.

Le HY300 illustre parfaitement cette approche.

Le système reste largement conforme à Android Open Source Project (AOSP), mais plusieurs couches propriétaires viennent enrichir son fonctionnement.

---

# Première couche : le matériel

La couche la plus basse est naturellement le matériel.

Dans notre cas, il s'agit principalement de :

- SoC Rockchip RK3326 ;
- mémoire LPDDR ;
- stockage eMMC ;
- contrôleur Wi-Fi ;
- GPU Mali ;
- contrôleur HDMI ;
- moteur d'affichage ;
- capteurs utilisés pour l'autofocus et la correction trapézoïdale.

Cette couche ne connaît absolument rien d'Android.

Elle expose uniquement des registres matériels.

---

# Deuxième couche : le noyau Linux

Au-dessus du matériel se trouve le noyau Linux.

Le noyau est responsable de :

- l'ordonnancement des processus ;
- la gestion de la mémoire ;
- la communication avec les périphériques ;
- les systèmes de fichiers ;
- les pilotes.

Le noyau constitue le véritable système d'exploitation.

Android n'est, à proprement parler, qu'un ensemble de logiciels fonctionnant au-dessus de Linux.

Cette distinction est souvent méconnue.

---

# Troisième couche : les pilotes

Les pilotes assurent la communication entre Linux et le matériel.

Sur le HY300, plusieurs familles de pilotes sont utilisées :

- GPU ;
- audio ;
- HDMI ;
- Wi-Fi ;
- Bluetooth ;
- USB ;
- stockage ;
- affichage.

Une grande partie de ces pilotes est spécifique à Rockchip.

Ils expliquent pourquoi il est impossible d'utiliser directement un noyau Linux générique sans adaptation.

---

# Quatrième couche : les bibliothèques natives

Une fois les pilotes chargés, Android s'appuie sur plusieurs centaines de bibliothèques partagées.

Parmi les plus importantes :

- Bionic (`libc`)
- libbinder
- libutils
- libgui
- libEGL
- libGLES
- MediaCodec
- Stagefright

Ces bibliothèques fournissent les services de bas niveau utilisés par le reste du système.

Dans le cas du HY300, nous avons également identifié plusieurs bibliothèques propriétaires spécifiques au constructeur.

Leur rôle sera étudié dans les volumes consacrés au reverse engineering.

---

# Cinquième couche : HAL

La Hardware Abstraction Layer (HAL) constitue l'une des particularités majeures d'Android.

Son objectif est simple.

Éviter que le Framework Android dialogue directement avec les pilotes.

À la place, Android communique avec une interface stable.

Cette séparation facilite énormément les mises à jour.

Google peut faire évoluer Android sans imposer aux constructeurs de réécrire l'ensemble de leurs pilotes.

Sur le HY300, les composants liés au projecteur exploitent largement cette architecture.

---

# Sixième couche : Binder

L'un des éléments les plus importants d'Android est Binder.

Binder est le mécanisme officiel de communication inter-processus (IPC).

Sans lui :

- ActivityManager ne pourrait pas dialoguer avec les applications ;
- PackageManager ne pourrait pas installer d'APK ;
- WindowManager ne pourrait pas créer de fenêtres.

Binder est partout.

La majorité des appels système Android transitent par ce mécanisme.

---

# Septième couche : System Server

Le processus `system_server` est souvent considéré comme le cerveau d'Android.

Il héberge notamment :

- ActivityManagerService ;
- WindowManagerService ;
- PackageManagerService ;
- PowerManagerService ;
- AudioService ;
- DisplayManagerService.

Lorsque System Server tombe, Android devient pratiquement inutilisable.

Une grande partie des applications OEM du HY300 repose indirectement sur ces services.

---

# Huitième couche : le Framework Android

Le Framework Android fournit les API utilisées par les applications.

Il masque la complexité du noyau Linux.

Grâce à lui, un développeur peut :

- créer une activité ;
- ouvrir une caméra ;
- jouer une vidéo ;
- accéder au réseau.

Sans connaître les pilotes sous-jacents.

Cette couche est largement héritée d'AOSP.

---

# Neuvième couche : les applications OEM

C'est ici que commence la personnalisation du constructeur.

Le HY300 ajoute plusieurs applications spécifiques.

Parmi elles :

- Launcher ;
- OTA ;
- Keystone ;
- Projection ;
- outils de maintenance.

Ces applications donnent l'impression de constituer le système.

En réalité, elles ne représentent que la partie visible de l'iceberg.

Elles reposent entièrement sur les couches inférieures.

---

# Dixième couche : les applications utilisateur

Enfin viennent les applications installées par l'utilisateur.

Netflix.

YouTube.

Kodi.

VLC.

Navigateur.

Ces applications ne dialoguent jamais directement avec le matériel.

Elles utilisent exclusivement les API du Framework Android.

Cette isolation constitue l'un des principaux mécanismes de sécurité du système.

---

# Où se situe le constructeur ?

L'une des questions les plus importantes de cette étude est la suivante.

**Où le constructeur est-il intervenu ?**

Notre analyse montre qu'il intervient principalement à quatre niveaux.

1. Les bibliothèques natives.
2. Les HAL.
3. Les services OEM.
4. Les applications système.

En revanche, les couches Linux et Framework restent très proches de celles fournies par AOSP.

Cette observation est fondamentale.

Elle explique pourquoi il est possible d'optimiser profondément le firmware sans avoir à reconstruire Android dans son intégralité.

---

# Architecture spécifique du HY300

Les observations réalisées pendant cette enquête montrent que le HY300 suit largement l'architecture Android moderne recommandée par Google.

Cependant, plusieurs particularités méritent d'être soulignées.

## Android 12

Le firmware repose sur Android 12.

Cette version introduit notamment :

- les partitions dynamiques ;
- les modules APEX ;
- Project Treble généralisé ;
- une séparation plus stricte entre les composants système et constructeur.

---

## Plateforme Rockchip

Le SoC RK3326 influence directement plusieurs couches.

Notamment :

- les pilotes ;
- les HAL ;
- les bibliothèques graphiques ;
- les services matériels.

Ces composants seront étudiés plus loin dans l'ouvrage.

---

## Composants propriétaires

Notre analyse a également révélé plusieurs éléments propres au constructeur.

Ils concernent principalement :

- la correction trapézoïdale ;
- l'autofocus ;
- les mises à jour OTA ;
- certaines applications système.

Leur fonctionnement exact fera l'objet d'un reverse engineering détaillé.

---

# Ce que ce chapitre nous apprend

À ce stade, une conclusion importante peut être formulée.

Le HY300 n'est pas un système Android profondément modifié.

Il s'agit d'une base Android relativement standard, enrichie par plusieurs couches OEM spécialisées.

Cette architecture explique pourquoi certaines optimisations sont simples à réaliser tandis que d'autres nécessitent une compréhension approfondie des interactions entre les différentes couches du système.

---

# Points clés

> [!IMPORTANT]
>
> Une application visible à l'écran ne représente qu'une infime partie du système Android.
>
> Les performances, la stabilité et les fonctionnalités dépendent principalement des couches inférieures : noyau Linux, HAL, bibliothèques natives, services système et composants OEM.

---

# Conclusion

Comprendre cette architecture globale est indispensable avant d'étudier les mécanismes spécifiques au HY300.

Les chapitres suivants descendront progressivement dans les couches les plus basses du système.

Nous commencerons par le tout premier instant de la vie du projecteur : le démarrage.

Nous suivrons le chemin parcouru par chaque instruction, depuis le BootROM gravé dans le SoC Rockchip jusqu'au lancement du Launcher Android.

---

## Chapitre suivant

➡️ **11 – Chaîne de démarrage Rockchip**