---
title: "QuickShare et USBDisplay : Reverse Engineering des fonctions de projection"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 24 — QuickShare et USBDisplay

> *« Ce qui fait d'un vidéoprojecteur Android un véritable projecteur n'est pas Android lui-même, mais les services qui permettent de recevoir et d'afficher une image provenant d'un autre appareil. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre le rôle des applications QuickShare et USBDisplay ;
- relier ces applications aux services réseau observés ;
- comprendre les mécanismes Android utilisés pour la projection ;
- préparer l'analyse complète des protocoles de diffusion.

---

# Introduction

Contrairement à une tablette Android classique, le HY300 est conçu pour afficher du contenu provenant de sources externes.

Cette fonctionnalité repose sur plusieurs composants logiciels.

Deux applications ont immédiatement retenu notre attention :

```
QuickShare
```

et

```
USBDisplay
```

Leur nom laisse penser qu'elles sont responsables de la projection d'écran et de l'affichage externe.

Notre objectif est d'établir précisément leur rôle.

---

# Pourquoi ces applications sont importantes

Sans elles,

le projecteur perdrait une grande partie de son intérêt.

Elles assurent probablement plusieurs fonctions essentielles :

- projection sans fil ;
- réception d'un flux vidéo ;
- détection d'appareils ;
- gestion des connexions ;
- communication avec le Launcher.

Ces hypothèses devront être validées par l'analyse du code et des communications réseau.

---

# Méthodologie

L'étude repose sur trois approches complémentaires.

## Analyse statique

Décompilation des APK.

Outils :

```text
jadx

apktool

aapt2

apkanalyzer
```

---

## Analyse dynamique

Observation pendant l'exécution.

Outils :

```bash
logcat

dumpsys activity

dumpsys package

ps

top
```

---

## Analyse réseau

Observation des services exposés.

Outils utilisés durant notre enquête :

```text
nmap

adb

tcpdump (travaux futurs)

Wireshark (travaux futurs)
```

---

# Les observations réalisées

Au début de cette étude, un scan réseau complet du projecteur a été réalisé.

Cette étape avait un objectif simple :

identifier les services accessibles depuis le réseau local.

Les ports détectés constituent un indice précieux.

Ils permettent de relier les applications Android aux services effectivement exposés sur le réseau.

---

# Corrélation avec les APK

Une étape importante du reverse engineering consiste à répondre à une question simple.

Pour chaque port détecté :

> Quelle application Android est responsable ?

Cette corrélation sera réalisée progressivement.

Nous utiliserons notamment :

- les journaux système (`logcat`) ;
- les processus (`ps`) ;
- les sockets ouvertes (`ss`, `netstat` si disponibles) ;
- l'analyse du code Java et JNI.

---

# QuickShare

## Fonction probable

Le nom suggère un mécanisme de partage ou de projection sans fil.

Selon les plateformes Android, une telle application peut implémenter différents protocoles :

- Miracast ;
- DLNA ;
- protocoles propriétaires ;
- réception de flux multimédia.

À ce stade, nous n'avons pas confirmé lequel est utilisé sur le HY300.

---

## Axes d'analyse

Nous rechercherons notamment :

- activités principales ;
- services lancés au démarrage ;
- intents ;
- appels réseau ;
- bibliothèques natives ;
- appels JNI.

---

# USBDisplay

Le nom évoque une fonction d'affichage externe.

Plusieurs scénarios sont possibles :

- affichage via USB ;
- capture vidéo ;
- mode périphérique ;
- pilote spécifique.

Ces hypothèses devront être vérifiées par l'analyse du code et des composants système.

---

# Les services Android associés

Une application de projection ne travaille jamais seule.

Elle dialogue généralement avec :

- MediaProjection ;
- DisplayManager ;
- SurfaceFlinger ;
- AudioManager ;
- NetworkStack.

L'identification de ces interactions constituera une étape importante du reverse engineering.

---

# Recherche des bibliothèques natives

Nous rechercherons les appels suivants :

```java
System.loadLibrary()
```

Les bibliothèques natives associées pourront révéler :

- un moteur vidéo ;
- un codec spécifique ;
- un protocole propriétaire ;
- une implémentation performante du décodage.

---

# Analyse des permissions

Le manifeste sera inspecté avec attention.

Les permissions susceptibles d'apparaître incluent :

- INTERNET ;
- ACCESS_WIFI_STATE ;
- CHANGE_WIFI_STATE ;
- ACCESS_NETWORK_STATE ;
- RECORD_AUDIO ;
- CAMERA ;
- FOREGROUND_SERVICE.

Leur présence donnera des indications sur les fonctionnalités de l'application.

---

# Analyse des communications

Une fois les applications identifiées,

nous chercherons :

- les domaines contactés ;
- les adresses IP ;
- les sockets ;
- les ports ouverts ;
- les protocoles.

Nous distinguerons soigneusement :

## Observations

Ce qui est effectivement capturé.

## Interprétations

Ce que ces observations permettent de déduire.

---

# Interaction avec le Launcher

Le Launcher ne réalise probablement pas lui-même la projection.

Il déclenche simplement QuickShare ou USBDisplay.

Nous documenterons :

- les Intents utilisés ;
- les extras transmis ;
- les callbacks ;
- les retours vers l'interface utilisateur.

---

# Sécurité

Plusieurs questions guideront cette partie.

- Les composants sont-ils exportés ?
- Les services réseau nécessitent-ils une authentification ?
- Les communications sont-elles chiffrées ?
- Existe-t-il des interfaces accessibles sans autorisation ?

Ces questions ne seront tranchées qu'après observation expérimentale.

---

# Ce que nous savons déjà

## Faits

- Les applications QuickShare et USBDisplay sont présentes.
- Elles participent aux fonctions de projection.
- Le projecteur expose plusieurs services réseau observés lors du scan initial.

## Ce qui reste à démontrer

Nous n'avons pas encore établi :

- quel protocole exact est utilisé ;
- quelle application ouvre quel port ;
- quelles bibliothèques natives sont chargées ;
- comment s'effectue l'authentification éventuelle.

---

# Travaux futurs

Les prochaines étapes incluront :

- décompilation complète des APK ;
- cartographie des activités ;
- capture réseau pendant une projection ;
- analyse des échanges Binder ;
- corrélation entre les processus Android et les ports réseau.

Ces résultats viendront compléter ce chapitre.

---

# Conclusion

QuickShare et USBDisplay constituent le lien entre Android et la fonction première du HY300 : projeter du contenu provenant d'un autre appareil.

L'analyse de ces composants permettra de comprendre comment le constructeur a intégré les fonctions de projection dans une architecture Android standard.

Ce chapitre marque également la transition entre l'analyse des applications visibles et l'étude des services système qui fonctionnent en arrière-plan.

---

> [!IMPORTANT]
> À ce stade de l'étude, plusieurs hypothèses existent quant aux protocoles de projection utilisés. Elles ne seront considérées comme établies qu'après décompilation des applications et captures réseau en situation réelle.

---

# Chapitre suivant

➡️ **25 – Daemon12138 : découverte d'un démon système inattendu**