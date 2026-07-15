---
title: "TxczTest et RKDeviceTest"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 22 — TxczTest et RKDeviceTest

> *« Derrière chaque appareil Android se cache généralement un ensemble d'outils destinés aux ingénieurs, aux chaînes de production et aux centres de maintenance. Ces outils sont rarement visibles par l'utilisateur, mais ils offrent un aperçu précieux de l'architecture interne du système. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre le rôle probable de TxczTest et RKDeviceTest ;
- distinguer les outils destinés à la production de ceux destinés au support technique ;
- préparer une analyse approfondie de leurs composants ;
- identifier les éléments qui pourraient révéler des fonctionnalités cachées.

---

# Introduction

Lors de l'inventaire des applications OEM, deux composants ont immédiatement retenu notre attention :

```
TxczTest
```

et

```
RKDeviceTest
```

Leur nom suggère qu'ils ne sont pas destinés aux utilisateurs finaux mais aux équipes techniques du constructeur.

Sur les plateformes Rockchip, ce type d'application est fréquemment utilisé pour :

- valider le matériel en usine ;
- tester les périphériques ;
- vérifier les performances ;
- faciliter le diagnostic après-vente.

L'objectif de ce chapitre est d'établir un premier état des lieux avant une analyse plus poussée.

---

# Méthodologie

L'étude d'une application système suit toujours la même démarche.

## Identification

Nous commençons par localiser l'APK :

```bash
find system product vendor -iname "*test*.apk"
```

Puis nous relevons :

- son emplacement ;
- sa taille ;
- sa partition d'origine.

---

## Décompilation

Les outils suivants seront utilisés :

```text
apktool

jadx

apkanalyzer

aapt2
```

Ils permettront d'extraire :

- AndroidManifest.xml ;
- les ressources ;
- les classes Java ;
- les éventuelles bibliothèques natives.

---

# Pourquoi ces applications sont intéressantes

Les applications de test constructeur possèdent souvent des privilèges importants.

Elles peuvent :

- accéder directement au matériel ;
- lancer des diagnostics internes ;
- modifier certaines propriétés système ;
- communiquer avec des services OEM.

Il est donc essentiel de comprendre leurs capacités avant toute modification du firmware.

---

# TxczTest

## Hypothèse fonctionnelle

Au vu de son nom, `TxczTest` semble être un outil de diagnostic développé par le constructeur.

Les fonctionnalités potentielles incluent :

- test des entrées utilisateur ;
- validation de l'affichage ;
- contrôle audio ;
- vérification réseau ;
- consultation d'informations système.

À ce stade, ces fonctionnalités restent à confirmer par l'analyse du code.

---

## Axes d'analyse

Nous examinerons notamment :

- les activités (`Activities`) ;
- les services (`Services`) ;
- les récepteurs (`Broadcast Receivers`) ;
- les permissions demandées ;
- les composants exportés ;
- les éventuelles interfaces cachées.

---

# RKDeviceTest

Le nom `RKDeviceTest` laisse penser qu'il s'agit d'un outil plus directement lié à la plateforme Rockchip.

Contrairement à `TxczTest`, qui semble spécifique au constructeur, cette application pourrait fournir des tests génériques pour le matériel.

Les points suivants seront recherchés :

- informations CPU ;
- mémoire ;
- stockage ;
- interfaces USB ;
- Wi-Fi ;
- Bluetooth ;
- HDMI ;
- capteurs.

---

# Analyse du manifeste

L'une des premières étapes consistera à examiner le manifeste Android.

Les éléments suivants seront documentés.

## Activités

Quelles interfaces utilisateur sont disponibles ?

Certaines sont-elles masquées ?

---

## Services

Des services tournent-ils en arrière-plan ?

Sont-ils lancés automatiquement ?

---

## Receivers

Quels événements Android déclenchent l'application ?

Par exemple :

- BOOT_COMPLETED ;
- CONNECTIVITY_CHANGE ;
- PACKAGE_ADDED.

---

## Permissions

Une attention particulière sera portée aux permissions sensibles.

Par exemple :

- WRITE_SECURE_SETTINGS ;
- READ_LOGS ;
- SYSTEM_ALERT_WINDOW ;
- REQUEST_INSTALL_PACKAGES.

---

# Analyse du code

Une fois le manifeste étudié, le code sera inspecté.

Les objectifs seront les suivants :

- identifier les classes principales ;
- rechercher des appels JNI ;
- détecter des commandes shell ;
- repérer des propriétés système (`getprop`, `setprop`) ;
- identifier les interfaces Binder.

---

# Recherche de composants cachés

Les applications de test contiennent parfois des fonctions non exposées dans l'interface graphique.

Nous rechercherons notamment :

- activités désactivées ;
- menus de maintenance ;
- codes d'accès ;
- modes usine ;
- intents non documentés.

---

# Analyse dynamique

L'application sera ensuite observée en fonctionnement.

Les outils utilisés incluront :

```bash
logcat

dumpsys activity

dumpsys package

am start
```

L'objectif sera d'identifier :

- les journaux générés ;
- les services lancés ;
- les interactions avec le système.

---

# Analyse de sécurité

Les questions suivantes guideront cette partie.

## Les composants sont-ils exportés ?

Un composant exporté peut parfois être appelé par une autre application.

Il convient de vérifier si cela est intentionnel.

---

## Les permissions sont-elles correctement protégées ?

Certaines applications constructeur disposent de privilèges élevés.

Il est important de vérifier si ces privilèges sont limités aux composants internes.

---

## L'application lance-t-elle des commandes système ?

Nous rechercherons des appels vers :

- `Runtime.exec()`
- `ProcessBuilder`
- `su`
- `setprop`
- `reboot`

Ces éléments peuvent révéler des fonctions de maintenance.

---

# Ce que nous savons déjà

## Faits

- Les deux applications sont présentes dans le firmware.
- Elles ne font pas partie d'AOSP.
- Leur nom évoque clairement des outils de test.

## Ce qui reste à démontrer

Nous n'avons pas encore confirmé :

- leurs fonctionnalités exactes ;
- leurs permissions ;
- leurs composants exportés ;
- leurs interactions avec les services OEM.

Ces éléments seront documentés après décompilation.

---

# Conclusion

Les applications TxczTest et RKDeviceTest constituent des candidats privilégiés pour comprendre les mécanismes internes du HY300.

Bien qu'elles semblent destinées au diagnostic ou à la fabrication, elles peuvent également révéler des interfaces, des services ou des fonctionnalités absents de l'interface utilisateur classique.

Leur étude détaillée contribuera à une meilleure compréhension du firmware et de l'architecture logicielle du projecteur.

---

> [!IMPORTANT]
> Les conclusions présentées dans ce chapitre reposent sur l'identification des applications et sur les pratiques courantes observées sur les plateformes Android embarquées. Les fonctionnalités précises ne seront considérées comme établies qu'après analyse du manifeste, du code et du comportement à l'exécution.

---

# Chapitre suivant

➡️ **23 – Launcher OEM : anatomie de l'interface utilisateur du HY300**