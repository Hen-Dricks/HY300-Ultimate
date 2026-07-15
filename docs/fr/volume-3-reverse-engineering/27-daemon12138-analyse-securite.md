---
title: "Daemon12138 : analyse de sécurité et évaluation des risques"
author: "HY300 Ultimate Research"
version: "1.0"
language: "fr"
status: "Draft"
last_updated: "2026-07-14"
---

# Chapitre 27 — Daemon12138 : analyse de sécurité et évaluation des risques

> *« Un composant propriétaire n'est ni sûr, ni dangereux par nature. Seule une analyse technique permet d'évaluer son niveau de risque. »*

---

# Résumé exécutif

Daemon12138 est un composant propriétaire identifié lors de notre analyse du firmware du HY300.

Son nom ne correspond à aucun composant documenté dans Android Open Source Project (AOSP), ce qui justifie une étude spécifique.

À ce stade de notre recherche :

- nous avons confirmé son existence ;
- nous avons identifié sa présence dans le firmware ;
- nous n'avons identifié aucun élément permettant d'affirmer qu'il est malveillant.

Ce chapitre présente une méthode d'analyse de sécurité destinée à déterminer objectivement son rôle, ses privilèges et son exposition.

---

# Objectifs

Ce chapitre répond aux questions suivantes :

- Quel est le niveau de privilège de Daemon12138 ?
- Quelles ressources système peut-il utiliser ?
- Expose-t-il une surface réseau ?
- Communique-t-il avec Internet ?
- Est-il accessible depuis d'autres applications ?
- Représente-t-il un risque particulier ?

---

# Périmètre de l'analyse

Cette étude couvre :

- le binaire Daemon12138 ;
- ses fichiers de configuration ;
- ses scripts de lancement ;
- ses propriétés Android ;
- ses communications locales ;
- ses communications réseau ;
- ses privilèges Linux ;
- ses interactions avec Android.

Elle ne couvre pas les composants tiers éventuellement téléchargés ultérieurement.

---

# Méthodologie

Notre approche repose sur plusieurs axes complémentaires.

## Analyse statique

Étude du binaire sans exécution.

Outils :

```text
strings

readelf

objdump

nm

file

sha256sum
```

Objectifs :

- identifier les chaînes de caractères ;
- déterminer l'architecture ;
- rechercher des URLs ;
- détecter des appels système ;
- identifier des bibliothèques.

---

## Analyse dynamique

Observation du démon en fonctionnement.

Outils :

```bash
ps

top

logcat

dmesg

cat /proc/<PID>/*
```

Objectifs :

- observer son comportement réel ;
- mesurer son activité ;
- identifier ses interactions.

---

## Analyse réseau

Recherche de communications.

Outils :

```bash
ss -lpn

netstat

tcpdump

Wireshark
```

Objectifs :

- détecter les sockets ouvertes ;
- identifier les ports utilisés ;
- déterminer si des communications externes existent.

---

## Analyse Android

Inspection des interactions avec le framework.

Outils :

```bash
dumpsys

service list

getprop

logcat
```

Objectifs :

- identifier les services utilisés ;
- rechercher les propriétés Android ;
- observer les échanges Binder.

---

# Privilèges

L'une des premières étapes consiste à déterminer :

- UID ;
- GID ;
- capacités Linux ;
- contexte SELinux.

Les commandes utilisées seront :

```bash
cat /proc/<PID>/status

ps -A -o USER,PID,NAME

id
```

Ces informations permettront de savoir si le démon fonctionne :

- comme utilisateur standard ;
- comme utilisateur système ;
- avec des privilèges élevés.

---

# SELinux

Android repose largement sur SELinux.

Nous chercherons à identifier :

```bash
ls -Z

ps -Z
```

Le contexte SELinux du démon permettra de connaître :

- les ressources auxquelles il peut accéder ;
- les restrictions qui lui sont imposées.

---

# Bibliothèques chargées

Le démon peut charger plusieurs bibliothèques.

Commande :

```bash
cat /proc/<PID>/maps
```

Nous documenterons :

- bibliothèques Android ;
- bibliothèques OEM ;
- bibliothèques Rockchip.

---

# Surface réseau

Nous rechercherons les sockets ouvertes.

Questions :

- écoute-t-il sur TCP ?
- écoute-t-il sur UDP ?
- utilise-t-il Binder ?
- utilise-t-il uniquement des sockets Unix ?

À ce stade, aucune communication réseau spécifique n'a été attribuée à Daemon12138.

Toute attribution devra être confirmée par des captures réseau.

---

# Communications externes

Une attention particulière sera portée à :

- domaines contactés ;
- adresses IP ;
- certificats TLS ;
- fréquence des connexions.

L'absence de trafic observé sera également documentée si elle est confirmée expérimentalement.

---

# Surface d'attaque

Les principaux vecteurs étudiés seront :

## Binder

Le démon expose-t-il une interface Binder ?

---

## Intents

Une application peut-elle communiquer avec lui ?

---

## Socket Unix

Le démon écoute-t-il localement ?

---

## TCP / UDP

Le démon accepte-t-il des connexions réseau ?

---

## Propriétés Android

Peut-il être piloté via :

```bash
setprop
```

---

# Analyse des risques

À ce stade de l'étude :

## Faits établis

✓ composant propriétaire ;

✓ présent dans le firmware ;

✓ nécessite une analyse spécifique.

---

## Ce qui n'est pas démontré

Nous n'avons pas démontré :

- une activité réseau suspecte ;
- une persistance anormale ;
- une collecte de données ;
- un contournement de SELinux ;
- une élévation de privilèges.

Aucune de ces hypothèses ne doit être présentée comme un fait sans preuve expérimentale.

---

# Évaluation

L'évaluation ci-dessous est provisoire et sera révisée à mesure que de nouvelles données seront disponibles.

| Critère          | État        |
| ---------------- | ----------- |
| Identification   | ✓           |
| Localisation     | ✓           |
| Cycle de vie     | En cours    |
| Communications   | À confirmer |
| Surface réseau   | À confirmer |
| Binder           | À confirmer |
| SELinux          | À confirmer |
| Bibliothèques    | À confirmer |
| Risque documenté | Non établi  |

---

# Limites de l'analyse

Cette étude présente plusieurs limites.

Nous n'avons pas encore réalisé :

- la rétro-ingénierie complète du binaire ;
- l'observation prolongée en conditions réelles ;
- des captures réseau sur plusieurs scénarios d'utilisation ;
- une instrumentation dynamique.

Ces travaux feront l'objet de mises à jour ultérieures.

---

# Recommandations

Avant toute conclusion concernant Daemon12138 :

- documenter intégralement le binaire ;
- observer plusieurs cycles de fonctionnement ;
- analyser les journaux système ;
- corréler les observations réseau ;
- comparer plusieurs versions du firmware.

Cette démarche permettra d'éviter toute interprétation hâtive.

---

# Conclusion

Daemon12138 constitue un excellent exemple de composant propriétaire nécessitant une analyse méthodique.

Sa présence dans le firmware justifie une investigation approfondie.

En revanche, les éléments actuellement disponibles ne permettent pas de conclure à un comportement anormal ou malveillant.

Cette distinction est essentielle.

L'objectif de ce projet n'est pas de rechercher des anomalies à tout prix, mais de produire une documentation technique fiable, fondée sur des preuves et reproductible.

---

> [!WARNING]
> Un nom inhabituel ou l'absence de documentation publique ne constituent pas des indicateurs de compromission. Toute évaluation de sécurité doit être fondée sur des observations techniques vérifiables et reproductibles.

---

# Chapitre suivant

➡️ **28 – Keystone : architecture, propriétés système et contrôle de la correction trapézoïdale**