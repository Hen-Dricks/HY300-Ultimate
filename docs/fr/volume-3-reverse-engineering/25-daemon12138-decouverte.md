---
title: "Daemon12138 : découverte d'un démon système inattendu"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 25 — Daemon12138 : découverte d'un démon système inattendu

> *« Le reverse engineering ne consiste pas uniquement à lire du code. Il consiste aussi à remarquer ce qui semble inhabituel, puis à comprendre pourquoi ce composant existe. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre comment un démon système peut être découvert ;
- reproduire notre méthodologie d'investigation ;
- distinguer une simple observation d'une hypothèse ;
- comprendre pourquoi Daemon12138 a retenu notre attention.

---

# Introduction

Toutes les plateformes Android exécutent des dizaines, parfois des centaines de processus système.

La plupart appartiennent directement à Android :

- system_server
- surfaceflinger
- audioserver
- mediaserver
- installd
- netd

Leur présence est normale.

Au cours de notre enquête, un autre processus est apparu.

Son nom était inhabituel :

```
Daemon12138
```

Aucune documentation constructeur n'explique son rôle.

Aucune référence officielle Android ne mentionne ce composant.

C'est précisément ce type de découverte qui justifie une analyse approfondie.

---

# Contexte de la découverte

L'objectif initial n'était pas de rechercher ce démon.

Notre enquête portait principalement sur :

- les performances du projecteur ;
- les applications OEM ;
- les communications réseau ;
- les composants de démarrage.

L'apparition de Daemon12138 est donc le résultat d'une observation réalisée au cours de cette exploration.

Cette approche est importante.

Nous n'avons pas cherché à confirmer une théorie préexistante.

Nous avons simplement documenté ce que le système nous montrait.

---

# Pourquoi ce nom est-il inhabituel ?

Contrairement à :

```
surfaceflinger

audioserver

servicemanager

vold
```

le nom :

```
Daemon12138
```

ne correspond à aucun composant documenté d'AOSP.

Il évoque davantage un composant spécifique au constructeur.

À ce stade, le nom seul ne permet évidemment pas de conclure à sa fonction.

Il constitue simplement un indice.

---

# Notre méthodologie

Face à un processus inconnu, nous avons adopté une démarche systématique.

Pour chaque démon identifié, nous cherchons à répondre aux questions suivantes :

- Où est situé son exécutable ?
- Quel utilisateur l'exécute ?
- Quand est-il lancé ?
- Qui le lance ?
- Avec quels privilèges fonctionne-t-il ?
- Avec quels autres processus communique-t-il ?
- Ouvre-t-il des sockets réseau ?
- Est-il relancé automatiquement en cas d'arrêt ?

Cette méthode est indépendante du composant étudié et peut être appliquée à n'importe quel firmware Android.

---

# Première étape : identifier le processus

Les commandes typiquement utilisées sont :

```bash
ps -A

ps -ef

pidof Daemon12138
```

Une fois le PID obtenu, il devient possible d'examiner plus en détail le processus.

---

# Deuxième étape : localiser l'exécutable

Sous Linux, chaque processus possède un lien symbolique vers son exécutable.

```bash
ls -l /proc/<PID>/exe
```

Cette commande permet d'identifier le binaire réellement exécuté.

Selon les cas, il peut s'agir :

- d'un exécutable ELF ;
- d'un script shell ;
- d'un wrapper ;
- d'un lien symbolique.

---

# Troisième étape : identifier les fichiers ouverts

Un démon laisse souvent des indices dans les fichiers qu'il utilise.

```bash
ls -l /proc/<PID>/fd
```

Nous recherchons notamment :

- journaux ;
- sockets Unix ;
- périphériques ;
- fichiers de configuration.

---

# Quatrième étape : examiner les sockets

Un démon chargé de communiquer avec d'autres composants ouvre souvent des sockets.

Les commandes suivantes seront utilisées lorsque disponibles :

```bash
ss -lpn

netstat -tulpn
```

L'objectif est de déterminer si Daemon12138 :

- écoute sur le réseau ;
- communique uniquement localement ;
- utilise Binder ;
- ouvre des sockets Unix.

---

# Cinquième étape : rechercher son origine

Une fois le processus identifié, il faut comprendre pourquoi il existe.

Les recherches porteront notamment sur :

```bash
grep -R "Daemon12138" /system

grep -R "Daemon12138" /vendor

grep -R "Daemon12138" /odm
```

Nous rechercherons :

- scripts init ;
- fichiers RC ;
- propriétés Android ;
- bibliothèques ;
- APK.

---

# Ce que nous avons réellement observé

## Faits établis

Au moment de cette rédaction, nous pouvons affirmer :

- un composant nommé **Daemon12138** est présent dans le firmware étudié ;
- il ne fait pas partie des composants standard documentés d'AOSP ;
- il mérite une analyse spécifique en raison de son caractère propriétaire.

## Ce que nous ne savons pas encore

À ce stade, nous n'avons pas démontré :

- son rôle exact ;
- son cycle de vie ;
- ses interactions avec les autres composants ;
- ses communications réseau ;
- son niveau de privilège.

Ces questions guideront les chapitres suivants.

---

# Pourquoi documenter un tel composant ?

Les appareils Android embarqués contiennent souvent des services propriétaires.

Certains assurent des fonctions légitimes :

- gestion matérielle ;
- maintenance ;
- télémétrie ;
- mises à jour.

D'autres peuvent simplement refléter des choix d'architecture propres au constructeur.

L'objectif de cette étude n'est pas de qualifier Daemon12138 comme bénin ou problématique sans preuve.

Notre objectif est de comprendre précisément :

- ce qu'il fait ;
- quand il agit ;
- comment il est intégré au système.

---

# Une règle fondamentale

Dans les travaux de sécurité, un nom inhabituel ne constitue jamais une preuve.

Il s'agit uniquement d'un point de départ.

Toute conclusion devra être fondée sur :

- le code ;
- les journaux ;
- les communications observées ;
- les fichiers du firmware.

Cette distinction entre observation et interprétation est essentielle à la crédibilité du projet.

---

# Travaux futurs

Le chapitre suivant cherchera à répondre à plusieurs questions :

- Qui lance Daemon12138 ?
- Est-il déclaré dans un fichier `init.rc` ?
- Est-il relancé automatiquement ?
- Dépend-il d'une propriété Android ?
- Est-il associé à une application OEM ?

Ces analyses permettront de reconstituer son cycle de vie complet.

---

# Conclusion

La découverte de Daemon12138 illustre parfaitement l'intérêt d'une démarche méthodique de reverse engineering.

Ce composant, absent de la documentation publique d'Android, constitue un excellent exemple de fonctionnalité propriétaire nécessitant une investigation approfondie.

Sa simple présence ne permet pas de tirer de conclusions.

En revanche, elle justifie pleinement les analyses qui suivront.

---

> [!IMPORTANT]
> La découverte d'un composant inconnu ne constitue pas, en elle-même, un indicateur de comportement malveillant. Dans ce projet, chaque conclusion sera systématiquement étayée par des preuves techniques vérifiables.

---

# Chapitre suivant

➡️ **26 – Daemon12138 : mécanismes de lancement et de persistance**