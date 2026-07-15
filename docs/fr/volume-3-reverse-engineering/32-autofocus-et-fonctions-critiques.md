---
title: "Autofocus et fonctions critiques"
author: "HY300 Ultimate Research"
version: "1.0"
language: "fr"
status: "Draft"
last_updated": "2026-07-14"
---

# Chapitre 32 — Autofocus et fonctions critiques

> *« Ce qui distingue réellement un vidéoprojecteur Android d'une simple box Android n'est pas Android lui-même, mais l'ensemble des composants qui contrôlent le matériel optique. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre comment Android pilote les fonctions matérielles critiques du HY300 ;
- distinguer les couches logicielles impliquées dans ces fonctions ;
- identifier les points de passage entre le framework Android et le matériel ;
- préparer les travaux d'optimisation du firmware Ultimate.

---

# Introduction

Depuis le début de cette étude, nous avons analysé :

- le démarrage ;
- les partitions ;
- les applications OEM ;
- les services système ;
- les bibliothèques natives.

Il est désormais possible de reconstituer la chaîne complète reliant une action de l'utilisateur à une action physique du projecteur.

---

# Les fonctions critiques

Le HY300 doit gérer plusieurs fonctions qui n'existent pas sur un appareil Android classique.

Parmi elles :

- autofocus ;
- correction trapézoïdale ;
- réglages de projection ;
- gestion de l'affichage ;
- paramètres optiques.

Ces fonctions constituent le cœur de la valeur ajoutée du constructeur.

---

# Architecture générale

L'architecture fonctionnelle peut être représentée ainsi :

```text
Utilisateur

↓

Launcher

↓

Application OEM

↓

Binder

↓

Service système

↓

JNI

↓

Bibliothèque native

↓

HAL

↓

Pilote Linux

↓

Interface matérielle

↓

Composant physique
```

Cette représentation sera affinée à mesure que les analyses progresseront.

---

# L'autofocus

Le firmware comporte une fonctionnalité d'autofocus accessible depuis l'interface utilisateur.

À ce stade de l'étude, plusieurs éléments restent à documenter :

- le composant qui déclenche l'autofocus ;
- la bibliothèque native qui pilote le matériel ;
- le protocole de communication avec le moteur.

Ces points feront l'objet d'une analyse expérimentale.

---

# La correction trapézoïdale

Nous avons déjà étudié les principes généraux de Keystone.

Cette fonction implique :

- une transformation géométrique ;
- une mise à jour de l'affichage ;
- une interaction avec le pipeline graphique.

Les composants exacts responsables de ces opérations seront identifiés progressivement.

---

# Communication avec le matériel

Les bibliothèques natives jouent le rôle d'intermédiaire entre Android et le matériel.

Schéma simplifié :

```text
Java

↓

JNI

↓

Bibliothèque OEM

↓

Pilote Linux

↓

Bus matériel (I²C, GPIO, PWM ou autre)

↓

Composant physique
```

Le type exact de bus utilisé devra être confirmé par l'analyse des pilotes et des journaux.

---

# Les interfaces matérielles

Selon les plateformes Android embarquées, plusieurs interfaces peuvent être utilisées.

Par exemple :

- I²C ;
- GPIO ;
- PWM ;
- UART ;
- SPI.

Nous rechercherons des indices de leur utilisation dans :

- les journaux système ;
- les pilotes ;
- les bibliothèques natives.

Nous ne supposerons pas qu'un bus est utilisé sans preuve.

---

# Analyse des bibliothèques natives

Les recherches porteront notamment sur :

```bash
strings

readelf

nm

objdump
```

Les objectifs seront :

- identifier les appels liés à l'autofocus ;
- rechercher des fonctions de contrôle matériel ;
- documenter les dépendances.

---

# Analyse dynamique

Les scénarios suivants seront étudiés :

- activation de l'autofocus ;
- désactivation ;
- modification de Keystone ;
- changement de mode d'affichage.

Pendant ces essais, plusieurs outils seront utilisés :

```bash
logcat

dmesg

dumpsys

getprop
```

Les résultats permettront de corréler les actions utilisateur avec les réactions du système.

---

# Ce que nous savons

## Confirmé

- le HY300 dispose d'une fonction d'autofocus ;
- le firmware comporte une correction trapézoïdale ;
- plusieurs applications et bibliothèques OEM participent à ces fonctions.

## À confirmer

Nous n'avons pas encore établi :

- le composant responsable du contrôle direct du moteur ;
- la bibliothèque native principale ;
- les interfaces matérielles effectivement utilisées ;
- les échanges entre Android et le pilote.

Ces éléments seront ajoutés lorsque les preuves seront disponibles.

---

# Pistes d'optimisation

Une meilleure compréhension de cette architecture permettra notamment :

- d'optimiser les performances de Keystone ;
- d'améliorer la réactivité de l'autofocus ;
- de réduire les temps de recalcul ;
- d'identifier d'éventuels goulots d'étranglement.

Toute optimisation devra toutefois être validée expérimentalement.

---

# Conclusion

Les fonctions critiques du HY300 reposent sur une architecture répartie entre plusieurs couches logicielles.

Le framework Android n'interagit pas directement avec le matériel.

Les applications OEM, les services système, les bibliothèques natives et les pilotes coopèrent pour fournir les fonctionnalités qui caractérisent ce vidéoprojecteur.

Comprendre cette chaîne constitue une étape indispensable avant toute modification ou optimisation du firmware.

---

> [!IMPORTANT]
> Les mécanismes internes de l'autofocus et de Keystone ne doivent pas être déduits à partir de leur seul comportement visible. Toute conclusion devra être fondée sur l'analyse des bibliothèques, des pilotes, des journaux système et des observations expérimentales.

---

# Chapitre suivant

➡️ **33 – Conclusions du Volume III**