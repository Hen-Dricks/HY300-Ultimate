---
title: "Conclusions du Volume III"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 33 — Conclusions du Volume III

> *« Comprendre un firmware ne consiste pas uniquement à lire son code. Il s'agit de reconstruire l'ensemble de son architecture, de comprendre les intentions de ses concepteurs et de distinguer les faits des hypothèses. »*

---

# Résumé exécutif

Le Volume III marque une étape majeure du projet HY300 Ultimate.

Après avoir étudié l'architecture générale d'Android dans le Volume II, nous avons entrepris une analyse approfondie des composants propriétaires intégrés au firmware du vidéoprojecteur.

Cette analyse avait plusieurs objectifs :

- identifier les applications développées par le constructeur ;
- comprendre leur interaction avec Android ;
- documenter les services système propriétaires ;
- analyser les bibliothèques natives ;
- préparer l'étude des mécanismes matériels.

Au terme de cette première phase, une cartographie cohérente de l'écosystème logiciel du HY300 commence à émerger.

---

# Ce que nous avons confirmé

Les éléments suivants ont été établis grâce aux observations réalisées au cours de cette étude.

## Applications OEM

Nous avons identifié plusieurs applications spécifiques au constructeur.

Parmi elles :

- Launcher OEM
- TXCZ OTA
- TxczTest
- RKDeviceTest
- QuickShare
- USBDisplay

Ces applications constituent la couche fonctionnelle ajoutée par le constructeur au-dessus d'Android.

---

## Services propriétaires

Notre enquête a permis d'identifier plusieurs services et composants qui ne font pas partie d'Android Open Source Project.

Ils assurent notamment :

- les mises à jour OTA ;
- les fonctions de projection ;
- les diagnostics ;
- la gestion de Keystone ;
- les interactions avec le matériel.

---

## Bibliothèques natives

Le firmware embarque également plusieurs bibliothèques natives spécifiques.

Ces composants jouent un rôle fondamental dans :

- les performances ;
- les traitements graphiques ;
- les interactions JNI ;
- la communication avec les pilotes.

Leur étude constitue désormais l'un des axes principaux du projet.

---

# Une architecture plus complexe qu'il n'y paraît

Le HY300 ne se résume pas à un simple Android TV adapté à un projecteur.

Notre étude met en évidence une architecture logicielle stratifiée :

```text
Utilisateur

↓

Applications OEM

↓

Framework Android

↓

Services Binder

↓

Bibliothèques natives

↓

HAL

↓

Pilotes Linux

↓

SoC Rockchip

↓

Composants optiques
```

Chaque couche possède son propre rôle et communique avec les autres selon des mécanismes bien définis.

---

# Les principaux enseignements

Cette étude montre que le constructeur s'appuie largement sur les mécanismes standards d'Android.

Plutôt que de modifier profondément le système, il ajoute des composants spécialisés :

- applications système ;
- services propriétaires ;
- bibliothèques natives ;
- scripts init ;
- propriétés Android.

Cette approche facilite la maintenance tout en permettant d'intégrer des fonctions spécifiques au vidéoprojecteur.

---

# Ce qui reste à démontrer

Malgré les nombreuses observations réalisées, plusieurs questions restent ouvertes.

Par exemple :

- quels services Binder relient précisément les applications OEM aux bibliothèques natives ?
- quelles bibliothèques pilotent directement Keystone ?
- comment fonctionne exactement l'autofocus ?
- quel est le rôle complet de Daemon12138 ?
- quelles optimisations graphiques spécifiques ont été intégrées par le constructeur ?

Ces points feront l'objet d'analyses complémentaires.

---

# Ce que cette étude ne prétend pas démontrer

Il est important de rappeler plusieurs limites.

La présence :

- d'un démon propriétaire ;
- d'une bibliothèque native ;
- d'une propriété Android inhabituelle ;

ne constitue pas une preuve de comportement malveillant.

Notre objectif est uniquement :

- documenter ;
- comprendre ;
- reproduire.

Toute conclusion de sécurité devra être fondée sur des preuves expérimentales.

---

# Une méthodologie reproductible

L'un des objectifs majeurs de ce projet consiste à proposer une méthode de travail reproductible.

Chaque conclusion repose sur :

- des commandes exécutées ;
- des fichiers extraits ;
- des journaux système ;
- des observations vérifiables.

Cette approche permet à d'autres chercheurs de reproduire les résultats sur un appareil identique.

---

# Apports à la communauté

La documentation produite dans ce volume ne se limite pas au HY300.

La plupart des méthodes présentées peuvent être appliquées à d'autres appareils Android embarqués utilisant :

- Rockchip ;
- Amlogic ;
- Allwinner ;
- MediaTek ;
- Qualcomm.

Le projet constitue donc également une référence méthodologique pour le reverse engineering des firmwares Android.

---

# Difficultés rencontrées

Comme toute étude de firmware propriétaire, plusieurs obstacles ont été rencontrés.

Parmi eux :

- absence de documentation officielle ;
- composants OEM non documentés ;
- bibliothèques natives sans symboles ;
- dépendances entre plusieurs partitions ;
- services invisibles ;
- composants démarrés très tôt pendant le boot.

Ces difficultés expliquent la nécessité d'une approche progressive.

---

# Perspectives

Les prochaines étapes du projet incluront notamment :

- décompilation complète des APK ;
- analyse approfondie des bibliothèques natives ;
- instrumentation dynamique ;
- observation Binder ;
- captures réseau ;
- comparaison entre plusieurs versions du firmware ;
- analyse des performances.

Ces travaux permettront de compléter les hypothèses formulées dans ce volume.

---

# Vers le Volume IV

Le Volume III a principalement étudié :

- l'architecture logicielle ;
- les composants OEM ;
- les interactions internes.

Le Volume IV changera de perspective.

Il sera consacré à la sécurité du firmware.

Les thèmes abordés incluront notamment :

- Android Verified Boot ;
- AVB ;
- vbmeta ;
- SELinux ;
- signatures ;
- certificats ;
- permissions privilégiées ;
- surface d'attaque ;
- durcissement du firmware.

L'objectif sera d'évaluer objectivement le niveau de sécurité du HY300.

---

# Conclusion générale

Le firmware du HY300 apparaît comme un exemple représentatif d'un appareil Android embarqué construit autour d'AOSP et enrichi par une importante couche logicielle propriétaire.

Cette étude montre qu'il est possible, sans disposer du code source constructeur, de reconstituer progressivement son architecture en s'appuyant sur des outils libres, une méthodologie rigoureuse et une documentation systématique.

Le travail présenté dans ce volume ne constitue pas une fin en soi.

Il représente une base solide qui pourra être enrichie par de futures analyses, par la communauté ou par de nouvelles versions du firmware.

---

> [!SUCCESS]
> Le Volume III clôt la première grande phase de reverse engineering logiciel du projet HY300 Ultimate. Grâce aux observations collectées et à la méthodologie adoptée, le projet dispose désormais d'une cartographie détaillée des principaux composants propriétaires du firmware et d'une base documentaire suffisamment structurée pour servir de référence aux analyses futures.

---

# Suite du projet

➡️ **Volume IV — Sécurité du firmware**

- Android Verified Boot
- AVB
- vbmeta
- SELinux
- Permissions privilégiées
- Signatures
- Certificats
- Surface d'attaque
- Hardening
- Recommandations