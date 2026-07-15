---
title: "Analyse et neutralisation contrôlée de Daemon12138"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 39 — Analyse et neutralisation contrôlée de Daemon12138

> *« La meilleure manière d'étudier un composant système n'est pas de le supprimer immédiatement, mais de comprendre précisément son rôle avant toute modification. »*

---

# Introduction

Depuis le Volume III, Daemon12138 constitue l'un des composants les plus intrigants du firmware.

Nous avons :

- identifié son existence ;
- étudié son cycle de vie ;
- recherché ses mécanismes de persistance ;
- commencé son analyse de sécurité.

Il reste maintenant une question essentielle.

Que se passe-t-il si ce composant n'est plus exécuté ?

Répondre à cette question est indispensable avant d'envisager une ROM débarrassée des composants inutiles.

---

# Objectif

L'objectif n'est **pas** de supprimer Daemon12138.

L'objectif est de répondre aux questions suivantes.

- Est-il réellement indispensable ?
- Quel est son rôle exact ?
- Dépend-il d'autres services ?
- D'autres services dépendent-ils de lui ?
- Son absence modifie-t-elle le comportement du système ?

---

# Philosophie

Une erreur fréquente consiste à supprimer immédiatement un APK ou un démon.

Nous avons volontairement adopté une stratégie différente.

```
Comprendre

↓

Mesurer

↓

Neutraliser

↓

Observer

↓

Conclure
```

Cette approche permet d'éviter les faux diagnostics.

---

# Les risques

Neutraliser un démon système peut provoquer :

- un bootloop ;
- une perte de fonctionnalités ;
- des erreurs silencieuses ;
- une consommation CPU inattendue ;
- des redémarrages en boucle.

Ces risques justifient une approche progressive.

---

# Préparation

Avant toute expérimentation, plusieurs éléments sont sauvegardés.

- partition system ;
- partition vendor ;
- scripts init ;
- configuration SELinux ;
- journaux système.

Cette sauvegarde permet un retour arrière immédiat.

---

# Les méthodes possibles

Plusieurs approches existent.

## Méthode 1

Renommer le binaire.

```
daemon

↓

daemon.disabled
```

Très simple.

Très réversible.

---

## Méthode 2

Modifier le fichier init.rc.

Le service n'est plus démarré.

Cette méthode est généralement préférable.

---

## Méthode 3

Modifier une propriété Android.

Si le démon dépend d'une propriété.

---

## Méthode 4

Neutraliser uniquement son lancement.

Le binaire reste présent.

Cette méthode facilite les comparaisons.

---

# Méthode retenue

Pour HY300 Ultimate,

la priorité est :

```
réversibilité
```

Nous privilégions donc une neutralisation qui :

- ne supprime aucun fichier ;
- peut être annulée rapidement ;
- n'empêche pas la restauration du firmware d'origine.

---

# Plan d'expérience

Chaque essai suit exactement le même protocole.

## Étape 1

Créer une nouvelle image système.

---

## Étape 2

Modifier uniquement Daemon12138.

Aucun autre changement.

---

## Étape 3

Reconstruire super.img.

---

## Étape 4

Flasher.

---

## Étape 5

Observer.

---

## Étape 6

Comparer.

---

# Critères de validation

Après démarrage,

nous vérifions :

✓ Android démarre.

✓ Le Launcher fonctionne.

✓ Keystone fonctionne.

✓ Autofocus fonctionne.

✓ Wi-Fi fonctionne.

✓ HDMI fonctionne.

✓ Projection fonctionne.

✓ Aucun redémarrage.

---

# Journaux

Pendant les essais,

nous enregistrons :

```bash
logcat -b all

dmesg

getprop

ps -A

top
```

Toutes les traces sont archivées.

---

# Analyse comparative

Chaque essai est comparé au firmware constructeur.

Exemple.

| Élément     | Firmware OEM | Ultimate   |
| ----------- | ------------ | ---------- |
| Boot        | OK           | OK         |
| Launcher    | OK           | OK         |
| Keystone    | OK           | ?          |
| Projection  | OK           | ?          |
| Daemon12138 | Présent      | Neutralisé |
| CPU         | ...          | ...        |
| RAM         | ...          | ...        |

---

# Scénarios possibles

## Cas 1

Aucun impact.

Le démon est probablement facultatif.

---

## Cas 2

Quelques fonctions disparaissent.

Le démon joue un rôle fonctionnel.

---

## Cas 3

Bootloop.

Le démon est critique.

---

## Cas 4

Le démon est automatiquement relancé.

Un watchdog existe probablement.

---

# Retour arrière

Toutes les modifications peuvent être annulées.

Il suffit de restaurer :

```
system.img

↓

super.img

↓

flash
```

Aucune perte définitive n'est possible.

---

# Journal de développement

**Objectif**

Évaluer l'impact réel de Daemon12138.

**Méthode**

Neutralisation réversible.

**Résultat**

À documenter après les essais.

**Décision**

Aucune conclusion ne sera tirée avant comparaison complète avec le firmware constructeur.

---

# Enseignements

Ce chapitre illustre un principe fondamental du reverse engineering.

Une modification n'a de valeur que si son impact peut être mesuré.

La neutralisation d'un composant n'est jamais une preuve de son inutilité.

Elle constitue simplement une expérience.

---

# Conclusion

Avant d'optimiser un firmware, il est indispensable d'identifier les composants réellement nécessaires.

Daemon12138 représente un excellent cas d'étude.

Sa neutralisation, réalisée de manière contrôlée et réversible, permettra de déterminer son importance réelle dans l'architecture logicielle du HY300.

Les résultats de cette expérimentation guideront les décisions futures concernant HY300 Ultimate.

---

> [!WARNING]
> Au moment de cette rédaction, ce chapitre décrit une **méthodologie d'expérimentation**. Il ne doit pas être interprété comme la preuve que Daemon12138 a été neutralisé avec succès ni que son rôle est désormais connu. Les conclusions seront mises à jour uniquement après des essais documentés et reproductibles.

---

# Chapitre suivant

➡️ **40 – Suppression contrôlée des applications OEM : méthodologie, dépendances et validation**