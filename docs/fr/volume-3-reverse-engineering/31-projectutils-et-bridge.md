---
title: "ProjectUtils et Bridge : les bibliothèques de liaison entre Android et le matériel"
author: "HY300 Ultimate Research"
version: "1.0"
language: "fr"
status: "Draft"
last_updated: "2026-07-14"
---

# Chapitre 31 — ProjectUtils et Bridge

> *« Les applications Android ne contrôlent presque jamais directement le matériel. Entre les deux se trouvent des bibliothèques de liaison qui constituent souvent la partie la plus intéressante du firmware constructeur. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre le rôle des bibliothèques natives OEM ;
- identifier les appels JNI ;
- comprendre le rôle des bibliothèques "Bridge" ;
- documenter les interfaces entre Java et le matériel ;
- préparer l'analyse complète des composants propriétaires.

---

# Introduction

Les applications Android sont écrites principalement en Java ou en Kotlin.

Le matériel, lui, est piloté par du code natif.

Il faut donc une passerelle.

Cette passerelle est généralement constituée :

- de bibliothèques `.so` ;
- d'interfaces JNI ;
- de services Binder ;
- de wrappers Java.

Sur le HY300, plusieurs composants semblent remplir ce rôle.

Notre objectif est de comprendre leur architecture.

---

# Pourquoi ces bibliothèques existent-elles ?

Android interdit volontairement aux applications d'accéder directement au matériel.

Une application ne peut pas :

- manipuler directement un moteur ;
- modifier une mémoire matérielle ;
- dialoguer avec un pilote Linux.

Elle passe par :

```
Java

↓

JNI

↓

Bibliothèque native

↓

HAL

↓

Driver Linux

↓

Matériel
```

Cette séparation améliore :

- la stabilité ;
- la sécurité ;
- la portabilité.

---

# Qu'entend-on par "Bridge" ?

Dans ce projet, le terme **Bridge** désigne toute couche logicielle qui assure une communication entre deux mondes :

- Java ↔ C++
- Framework ↔ HAL
- Service Android ↔ matériel

Il ne s'agit pas nécessairement d'une bibliothèque nommée "Bridge". Le terme décrit ici une fonction architecturale.

---

# Les composants recherchés

Notre analyse portera notamment sur :

```text
libprojectutils.so
libbridge.so
libkeystone.so
librkgfx.so
```

Les noms exacts dépendront du firmware.

Chaque composant identifié sera documenté.

---

# Méthodologie

Les bibliothèques natives seront étudiées avec plusieurs outils.

## Identification

```bash
find system vendor odm product -name "*.so"
```

---

## Informations ELF

```bash
file

readelf

objdump
```

---

## Symboles

```bash
nm

readelf -Ws
```

---

## Chaînes

```bash
strings
```

---

## Empreintes

```bash
sha256sum
```

Chaque résultat sera archivé dans :

```
assets/native-libraries/
```

---

# Analyse des dépendances

Une bibliothèque ne fonctionne jamais seule.

Nous établirons un graphe complet.

```
Launcher

↓

ProjectUtils

↓

JNI

↓

libkeystone

↓

HAL

↓

Driver
```

Chaque dépendance sera validée expérimentalement.

---

# JNI

Les appels JNI constituent un élément clé.

Nous rechercherons notamment :

```cpp
JNI_OnLoad

RegisterNatives

Java_com_

System.loadLibrary()
```

Ces éléments permettront de relier les méthodes Java aux fonctions natives.

---

# Binder

Une bibliothèque peut également communiquer avec un service Binder.

Nous rechercherons :

- ServiceManager
- IBinder
- transact()
- Parcel

Ces appels seront cartographiés.

---

# Appels matériels

Les bibliothèques OEM sont souvent responsables de :

- l'autofocus ;
- la correction trapézoïdale ;
- la luminosité ;
- la ventilation ;
- les LED ;
- les capteurs.

Nous rechercherons les fonctions associées.

---

# Analyse des chaînes

Les commandes :

```bash
strings libprojectutils.so

strings libbridge.so
```

permettront notamment de rechercher :

- URLs ;
- chemins ;
- propriétés Android ;
- noms de services ;
- messages de journalisation.

Ces chaînes fournissent souvent des indices précieux.

---

# Bibliothèques système

Nous distinguerons clairement :

## Bibliothèques AOSP

Exemples :

```
libbinder.so
libutils.so
liblog.so
libcutils.so
```

---

## Bibliothèques OEM

Exemples :

```
libprojectutils.so
librkgfx.so
libkeystone.so
```

Cette séparation facilitera les comparaisons avec d'autres firmwares.

---

# Ce que nous avons réellement observé

## Confirmé

- le firmware contient des bibliothèques natives OEM ;
- celles-ci complètent les composants standards d'Android ;
- elles constituent le point de passage privilégié entre les applications et le matériel.

## À confirmer

Nous n'avons pas encore établi :

- les dépendances complètes ;
- les interfaces JNI ;
- les services Binder associés ;
- les appels directs aux pilotes.

Ces éléments seront documentés progressivement.

---

# Documentation de chaque bibliothèque

Chaque bibliothèque disposera d'une fiche dédiée.

Exemple :

| Champ               | Contenu             |
| ------------------- | ------------------- |
| Nom                 | librkgfx.so         |
| SHA-256             | ...                 |
| Architecture        | ARM64               |
| Dépendances         | ...                 |
| Symboles            | ...                 |
| Fonctions JNI       | ...                 |
| Services Binder     | ...                 |
| Niveau de confiance | Confirmé / Probable |

Cette normalisation facilitera les recherches.

---

# Limites

Certaines bibliothèques peuvent être :

- entièrement dépourvues de symboles ;
- compilées avec optimisation ;
- partiellement obfusquées.

Dans ces cas, plusieurs techniques complémentaires (analyse dynamique, instrumentation, comparaison entre firmwares) pourront être nécessaires.

---

# Conclusion

Les bibliothèques natives représentent le véritable cœur des personnalisations constructeur.

Elles permettent aux applications Android d'accéder au matériel sans exposer directement les pilotes.

Leur analyse constitue l'une des étapes les plus importantes du reverse engineering du HY300.

---

> [!IMPORTANT]
> Une bibliothèque native ne révèle pas nécessairement sa fonction par son nom. Les conclusions devront toujours être fondées sur les symboles, les dépendances, les chaînes de caractères, les appels JNI et les observations à l'exécution.

---

# Chapitre suivant

➡️ **32 – Autofocus et fonctions critiques : analyse complète des composants matériels**