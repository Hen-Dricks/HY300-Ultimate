---
title: "Inventaire complet des applications OEM"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 20 — Inventaire complet des applications OEM

> *« Le firmware d'un appareil Android n'est pas uniquement constitué du système d'exploitation. Une grande partie de sa personnalité provient des applications ajoutées par le constructeur. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- identifier toutes les applications installées par défaut sur le HY300 ;
- distinguer les applications AOSP des applications OEM ;
- comprendre la structure logicielle du firmware ;
- identifier les composants responsables des principales fonctionnalités du projecteur ;
- préparer l'analyse détaillée des chapitres suivants.

---

# Introduction

Après avoir étudié l'architecture interne d'Android dans le Volume II, nous pouvons désormais commencer le véritable reverse engineering du firmware.

Le premier objectif consiste à dresser un inventaire exhaustif des composants logiciels installés par le constructeur.

Contrairement à un smartphone Android classique, un vidéoprojecteur embarque de nombreuses applications spécialisées :

- projection sans fil ;
- correction trapézoïdale ;
- autofocus ;
- diagnostic matériel ;
- mises à jour OTA ;
- maintenance ;
- interfaces de test usine.

Ces applications constituent la couche visible du travail réalisé par le constructeur.

Avant d'étudier leur fonctionnement, il est indispensable de les identifier précisément.

---

# Méthodologie

Notre démarche repose sur un principe simple :

> Aucun composant n'est étudié avant d'avoir été identifié, localisé et documenté.

L'inventaire a été réalisé à partir des partitions extraites du firmware ainsi que du système en fonctionnement via ADB.

Les principales commandes utilisées sont les suivantes.

```bash
find system product vendor odm -name "*.apk"

find system product vendor odm -name "*.jar"

pm list packages

pm list packages -f

dumpsys package
```

Chaque résultat a ensuite été comparé avec la documentation AOSP afin de distinguer :

- les composants Android standard ;
- les composants spécifiques au constructeur.

---

# Organisation générale du firmware

L'analyse montre que les applications sont réparties dans plusieurs partitions.

```text
system/

├── app/

├── priv-app/

product/

├── app/

vendor/

├── app/

```

Cette répartition est cohérente avec l'architecture Treble étudiée dans le volume précédent.

---

# Classification des applications

Les applications identifiées peuvent être regroupées en plusieurs catégories.

## Applications Android standard

Issues directement d'AOSP.

Exemples :

- Package Installer
- DocumentsUI
- Settings
- Bluetooth
- MediaProvider

Ces applications ne constituent pas l'objet principal de cette étude.

---

## Applications constructeur

Développées ou intégrées spécifiquement pour le HY300.

Exemples observés :

- TXCZ OTA
- TxczTest
- RKDeviceTest
- Launcher OEM
- QuickShare
- USBDisplay

Ces composants seront étudiés individuellement dans les chapitres suivants.

---

## Services invisibles

Le firmware embarque également plusieurs composants qui ne possèdent aucune interface graphique.

Ils sont néanmoins essentiels au fonctionnement du système.

Par exemple :

- services OTA ;
- services Keystone ;
- démon Daemon12138 ;
- scripts init ;
- services de restauration Recovery.

Ces composants sont souvent plus intéressants que les applications visibles.

---

# Première cartographie

L'analyse permet d'obtenir une vue d'ensemble.

```text
Utilisateur

↓

Launcher

↓

QuickShare

↓

USBDisplay

↓

TXCZ OTA

↓

Services Keystone

↓

Daemon12138

↓

Framework Android
```

Ce schéma servira de référence tout au long du Volume III.

---

# Les applications les plus importantes

Parmi toutes les applications recensées, plusieurs attirent immédiatement l'attention.

## TXCZ OTA

Responsable des mises à jour logicielles.

Elle sera étudiée dans le chapitre suivant.

---

## TxczTest

Application de diagnostic.

Elle contient probablement des interfaces destinées au support technique ou à la production.

---

## RKDeviceTest

Application de validation matérielle.

Elle permettra probablement d'identifier plusieurs interfaces internes.

---

## Launcher OEM

Interface principale du projecteur.

Elle constitue le point d'entrée de l'utilisateur.

---

## QuickShare

Gestion du partage sans fil.

Son fonctionnement sera étudié conjointement avec l'analyse réseau.

---

## USBDisplay

Gestion de l'affichage externe.

Cette application est directement liée aux capacités multimédias du projecteur.

---

## Daemon12138

Bien qu'il ne s'agisse pas d'une application visible, ce composant mérite une attention particulière.

Au cours de notre enquête, il est apparu comme l'un des processus les plus intéressants du firmware.

Trois chapitres lui seront consacrés.

---

# Applications système ou simples APK ?

Toutes les applications ne disposent pas du même niveau de privilège.

Android distingue notamment :

```text
system/app
```

et

```text
system/priv-app
```

Les applications placées dans `priv-app` peuvent obtenir des permissions inaccessibles aux applications ordinaires.

L'étude de leur manifeste permettra de comprendre précisément leurs privilèges.

---

# Analyse prévue

Pour chaque application OEM, nous appliquerons exactement la même méthodologie.

## Identification

- Nom du package
- Version
- Signature
- Taille
- Partition

## Manifest

- Activités
- Services
- Receivers
- Providers

## Permissions

- Permissions demandées
- Permissions privilégiées
- Permissions constructeur

## Code

- Classes Java
- Ressources
- Bibliothèques natives
- JNI

## Réseau

- Connexions
- URLs
- Protocoles
- OTA

## Sécurité

- Export des activités
- Validation des entrées
- Risques éventuels

Cette approche garantit une analyse homogène de l'ensemble du firmware.

---

# Ce que nous savons déjà

Grâce aux volumes précédents, plusieurs éléments sont déjà établis.

## Faits

- Le firmware repose sur Android 12.
- Les partitions dynamiques sont utilisées.
- Les services init sont conformes à AOSP.
- Les mécanismes OTA utilisent `applypatch`.
- Des applications OEM spécifiques sont présentes.

## Ce qu'il reste à découvrir

Nous ne savons pas encore :

- comment ces applications communiquent entre elles ;
- quels services Binder elles utilisent ;
- quelles bibliothèques natives elles chargent ;
- quelles interfaces cachées elles exposent ;
- quelles fonctionnalités sont réservées au mode usine.

Ces questions guideront l'ensemble du Volume III.

---

# Conclusion

Avant de disséquer un firmware, il est indispensable d'en établir une cartographie logicielle complète.

Ce chapitre constitue cette cartographie.

Il servira de point d'entrée pour toutes les analyses détaillées qui suivront.

Chaque application importante sera désormais étudiée individuellement, en suivant une méthodologie identique afin de produire une documentation homogène, reproductible et directement exploitable.

---

> [!IMPORTANT]
> Une application Android visible n'est souvent que la partie émergée de l'iceberg. Une grande partie de la logique du constructeur réside dans les services en arrière-plan, les bibliothèques natives et les scripts système qui l'accompagnent.

---

# Chapitre suivant

➡️ **21 – TXCZ OTA : reverse engineering complet du système de mise à jour**