---
title: "TXCZ OTA : Reverse Engineering complet du système de mise à jour"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 21 — TXCZ OTA : Reverse Engineering complet du système de mise à jour

> *« Les mises à jour OTA constituent l'un des composants les plus sensibles d'un appareil Android. Elles sont capables de modifier le système complet tout en garantissant son intégrité. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre l'architecture OTA du HY300 ;
- identifier les composants impliqués dans une mise à jour ;
- distinguer les composants AOSP des composants OEM ;
- comprendre le lien entre l'application OTA, Recovery et `applypatch` ;
- préparer une analyse complète du protocole OTA.

---

# Introduction

Toute plateforme Android moderne possède un mécanisme permettant de distribuer des mises à jour logicielles.

Ces mises à jour peuvent :

- corriger des bugs ;
- ajouter des fonctionnalités ;
- améliorer les performances ;
- corriger des failles de sécurité.

Sur le HY300, ce mécanisme repose sur plusieurs composants qui coopèrent.

Notre objectif est d'établir précisément leur rôle.

---

# Méthodologie

L'analyse s'est appuyée sur plusieurs sources.

## Extraction des APK

Les partitions système ont été explorées afin d'identifier les applications liées aux mises à jour.

Commandes utilisées :

```bash
find system product vendor -iname "*ota*"
find system product vendor -iname "*update*"
```

---

## Recherche des composants Recovery

Nous avons ensuite recherché tous les fichiers liés au processus OTA.

```bash
find /system /vendor -type f \
    \( -iname "*recovery*" \
    -o -iname "*ota*" \
    -o -iname "*applypatch*" \)
```

Cette recherche a permis d'identifier plusieurs composants essentiels.

---

# Composants identifiés

Notre enquête a mis en évidence les éléments suivants.

## Application OTA

```
txcz_ota.apk
```

Cette application constitue l'interface utilisateur du système de mise à jour.

Elle est responsable de la recherche, du téléchargement et du lancement des mises à jour.

---

## Script constructeur

```
/vendor/bin/install-recovery.sh
```

Nous avons analysé ce script dans le volume précédent.

Il contrôle l'intégrité de la partition Recovery.

---

## Service init

```
vendor_flash_recovery.rc
```

Ce service lance automatiquement le script précédent au démarrage.

---

## Patch Recovery

```
/vendor/recovery-from-boot.p
```

Patch binaire utilisé pour reconstruire Recovery si nécessaire.

---

## Certificats OTA

```
/system/etc/security/otacerts.zip
```

Archive contenant les certificats utilisés lors de la validation des mises à jour.

---

# Architecture générale

Les différents composants peuvent être représentés ainsi.

```text
Utilisateur

↓

TXCZ OTA

↓

Téléchargement OTA

↓

Recovery

↓

applypatch

↓

boot

↓

system

↓

Redémarrage
```

Cette architecture reste proche du modèle historique proposé par Android.

---

# Analyse de l'application OTA

À ce stade de l'étude, plusieurs observations peuvent être formulées.

## Faits observés

Nous avons confirmé :

- la présence de l'application ;
- la présence du script Recovery ;
- la présence du patch ;
- la présence du certificat OTA.

Ces composants démontrent qu'un mécanisme OTA complet est embarqué dans le firmware.

---

## Ce qui reste à analyser

Nous n'avons pas encore réalisé :

- la décompilation complète de l'APK ;
- l'analyse du manifeste ;
- l'identification des serveurs de mise à jour ;
- l'analyse des appels réseau ;
- l'étude des bibliothèques natives éventuellement embarquées.

Ces travaux seront documentés dans une révision ultérieure de ce chapitre.

---

# Le lien avec Recovery

L'application OTA ne modifie pas directement le système.

Elle délègue les opérations critiques à Recovery.

Cette séparation constitue un principe fondamental d'Android.

Le schéma simplifié est le suivant.

```text
APK OTA

↓

Recovery

↓

applypatch

↓

Partitions système
```

Ce fonctionnement limite les risques d'interruption pendant une mise à jour.

---

# Vérification des signatures

L'étude du fichier :

```
otacerts.zip
```

a montré que le certificat embarqué est différent de la clé de test publique AOSP.

Cette observation signifie que le constructeur utilise sa propre chaîne de confiance pour les mises à jour.

En revanche, nous n'avons pas démontré expérimentalement quelles vérifications sont effectivement appliquées lors d'une OTA.

---

# Surface d'analyse

L'application OTA présente plusieurs axes d'étude.

## Analyse statique

- AndroidManifest.xml
- Activities
- Services
- Broadcast Receivers
- Permissions
- Ressources
- Bibliothèques natives

---

## Analyse dynamique

- Logcat
- Intents
- Binder
- Processus lancés
- Téléchargements

---

## Analyse réseau

Les éléments suivants devront être documentés :

- domaines contactés ;
- protocole utilisé ;
- format des requêtes ;
- validation TLS ;
- fréquence des vérifications.

Aucune capture réseau n'a encore été réalisée dans le cadre de cette étude.

---

## Analyse de sécurité

Plusieurs questions restent ouvertes.

Par exemple :

- l'application vérifie-t-elle la signature avant téléchargement ou uniquement au moment de l'installation ?
- les composants sont-ils exportés ?
- existe-t-il des activités accessibles par Intent ?
- les mises à jour sont-elles différentielles ou complètes ?

Ces questions feront l'objet d'une analyse spécifique.

---

# Ce que nous savons déjà

À ce stade :

## Confirmé

✓ une application OTA est présente ;

✓ Recovery participe au processus ;

✓ `applypatch` est utilisé ;

✓ un certificat spécifique est embarqué ;

✓ un mécanisme automatique de restauration du Recovery existe.

---

## Non démontré

Nous n'avons pas encore établi :

- l'URL des serveurs OTA ;
- le protocole exact de téléchargement ;
- le format des paquets ;
- la présence éventuelle de signatures additionnelles.

---

# Travaux futurs

Les prochaines étapes de cette analyse consisteront à :

- décompiler entièrement `txcz_ota.apk` ;
- documenter son manifeste ;
- analyser ses classes Java ;
- identifier les bibliothèques JNI ;
- observer son comportement en fonctionnement ;
- capturer les communications réseau associées.

Ces résultats feront l'objet d'une mise à jour de ce chapitre.

---

# Conclusion

L'analyse préliminaire montre que le HY300 dispose d'un système OTA relativement classique, construit autour des mécanismes standards d'Android (Recovery, `applypatch`, certificats), enrichis par une application OEM et quelques composants spécifiques au constructeur.

La compréhension détaillée de cette application constituera une étape importante du reverse engineering du firmware.

---

> [!IMPORTANT]
> À ce stade de l'étude, plusieurs éléments de l'architecture OTA ont été identifiés, mais le protocole complet de mise à jour n'a pas encore été observé en fonctionnement. Les conclusions présentées ici distinguent volontairement les faits établis des analyses restant à confirmer.

---

# Chapitre suivant

➡️ **22 – TxczTest et RKDeviceTest : exploration des outils de diagnostic constructeur**