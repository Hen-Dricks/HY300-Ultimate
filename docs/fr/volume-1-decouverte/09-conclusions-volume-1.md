---
title: "Conclusions du volume I"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 9 — Conclusions du volume I

> *« Avant de comprendre comment un système fonctionne, il faut d'abord comprendre comment l'observer. »*

---

# Introduction

Le premier volume de cette étude ne contenait volontairement aucune modification profonde du firmware.

Aucune optimisation.

Aucun composant système supprimé.

Aucune bibliothèque remplacée.

Aucun patch appliqué.

Ce choix peut surprendre.

Pourtant, il constitue probablement la décision la plus importante de tout le projet.

L'objectif de cette première phase n'était pas de modifier le projecteur.

L'objectif était de comprendre dans quel environnement nous allions évoluer.

---

# Une approche différente des guides classiques

Une grande partie des tutoriels disponibles sur Internet suivent un schéma relativement simple.

1. Déverrouiller l'appareil.
2. Rooter le système.
3. Supprimer les applications jugées inutiles.
4. Installer une ROM modifiée.

Cette approche produit souvent un résultat fonctionnel.

En revanche, elle répond rarement à une question essentielle :

**Pourquoi ces manipulations fonctionnent-elles ?**

Notre démarche fut radicalement différente.

Nous avons choisi de documenter chaque étape avant toute modification.

Le firmware est devenu un objet d'étude.

Non un simple obstacle à contourner.

---

# Les principales découvertes

Au terme de cette première phase, plusieurs résultats importants peuvent déjà être considérés comme établis.

---

## Identification de la plateforme

Le nom commercial « HY300 » ne suffit pas à caractériser l'appareil.

Notre analyse a permis d'identifier :

- un SoC Rockchip RK3326 ;
- une plateforme logicielle `rk3326_sgo` ;
- Android 12 ;
- une architecture utilisant les partitions dynamiques.

Cette identification constitue désormais le point de référence de toute la suite de l'étude.

---

## Découverte d'ADB

L'une des découvertes majeures concerne le démon Android Debug Bridge.

Contrairement au comportement habituel :

- le port TCP 5555 n'est pas utilisé ;
- ADB est exposé sur le port **3268**.

Cette configuration n'est documentée par aucun document constructeur disponible au moment de cette recherche.

Elle représente donc une observation originale.

---

## Un démon root

Plus surprenant encore, le démon ADB accepte la commande :

```bash
adb root
```

Le résultat :

```text
restarting adbd as root
```

ouvre un accès privilégié rarement observé sur des appareils Android destinés au grand public.

Cette particularité explique pourquoi une grande partie de cette étude a pu être réalisée sans ouvrir physiquement le projecteur.

---

## Une architecture moderne

L'analyse préliminaire du firmware montre que le constructeur utilise pleinement les mécanismes introduits par Android récent.

Parmi eux :

- `super.img`
- partitions logiques
- `system_ext`
- `vendor_dlkm`
- `odm_dlkm`
- `product`

Cette architecture sera étudiée en détail dans le volume suivant.

---

## Des composants propriétaires nombreux

Même sans décompiler la moindre application, plusieurs indices montrent que le constructeur ajoute une couche logicielle importante au-dessus d'AOSP.

Nous avons identifié :

- des applications OEM ;
- des services privilégiés ;
- plusieurs bibliothèques natives ;
- un moteur Keystone ;
- des mécanismes OTA propriétaires.

Leur fonctionnement reste encore à comprendre.

---

# Les enseignements méthodologiques

Ce premier volume a également permis de valider plusieurs principes qui guideront l'ensemble de la suite du projet.

---

## Sauvegarder avant de modifier

Chaque partition importante a été sauvegardée.

Cette règle ne sera jamais abandonnée.

Elle garantit qu'une erreur reste réversible.

---

## Vérifier avant de conclure

Chaque hypothèse a été confrontée à des observations expérimentales.

Lorsque les preuves étaient insuffisantes, nous avons explicitement conservé le statut d'hypothèse.

Cette distinction est essentielle.

---

## Préférer les preuves aux intuitions

Plusieurs idées initiales se sont révélées fausses.

Par exemple :

- Fastboot n'était pas utilisable comme prévu.
- Le port 3268 n'hébergeait pas LDAP malgré la détection de Nmap.
- Certaines applications apparemment secondaires jouaient un rôle central dans le fonctionnement du système.

Ces erreurs ont permis d'améliorer notre compréhension du firmware.

---

# Ce qui reste à découvrir

Malgré plusieurs semaines de recherche, une grande partie du fonctionnement interne reste encore inconnue.

Parmi les questions ouvertes :

- Comment fonctionne exactement Keystone ?
- Quelles sont les interactions entre les applications OEM ?
- Quel est le rôle précis des composants natifs ?
- Comment le constructeur construit-il son firmware ?
- Comment fonctionne réellement la chaîne OTA ?
- Quels composants peuvent être supprimés sans conséquence ?
- Quels services doivent impérativement être conservés ?

Les volumes suivants tenteront d'apporter des réponses à chacune de ces questions.

---

# Ce que le lecteur sait désormais

À la fin de ce premier volume, le lecteur est capable de :

- identifier précisément la plateforme étudiée ;
- comprendre les objectifs de la recherche ;
- reproduire les premières étapes de découverte ;
- comprendre pourquoi ADB a été recherché ;
- comprendre comment il a été découvert ;
- comprendre pourquoi Fastboot n'a pas été retenu ;
- comprendre la philosophie générale du projet.

Autrement dit, il possède désormais le contexte nécessaire pour entrer dans l'analyse technique approfondie du système.

---

# Transition vers le volume II

Le premier volume s'est volontairement limité à la phase d'observation.

Le second volume changera complètement de perspective.

Nous ne chercherons plus simplement à accéder au système.

Nous chercherons à comprendre son architecture interne.

Nous analyserons notamment :

- le processus de démarrage Android ;
- `init` ;
- les propriétés système ;
- les partitions dynamiques ;
- les services privilégiés ;
- les mécanismes OEM ;
- les bibliothèques natives ;
- les applications système.

Autrement dit, nous passerons de la découverte à la compréhension.

---

> [!SUCCESS]
> Le premier objectif de cette recherche est désormais atteint.

> Nous disposons d'un accès complet au système, d'une sauvegarde intégrale du firmware et d'une méthodologie reproductible permettant d'étudier cette plateforme sans recourir à des modifications destructrices.

---

# Volume suivant

➡️ **Volume II — Architecture interne d'Android sur le HY300**

Le lecteur va désormais pénétrer au cœur du firmware et découvrir, couche par couche, comment le système est réellement construit.