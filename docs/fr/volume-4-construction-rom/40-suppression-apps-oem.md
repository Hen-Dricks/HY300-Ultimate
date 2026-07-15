---
title: "Suppression contrôlée des applications OEM"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 40 — Suppression contrôlée des applications OEM

> *« Une application système ne doit jamais être supprimée simplement parce qu'elle semble inutile. Dans un firmware embarqué, une simple APK peut être responsable d'une fonction essentielle. »*

---

# Introduction

L'objectif principal de HY300 Ultimate est de proposer un firmware plus léger, plus rapide et plus transparent.

Pour atteindre cet objectif, il est indispensable d'analyser les applications ajoutées par le constructeur.

Cependant, cette étape ne consiste pas à supprimer aveuglément des APK.

Chaque application doit d'abord être :

- identifiée ;
- comprise ;
- reliée à ses dépendances ;
- évaluée ;
- testée.

Ce n'est qu'après cette analyse qu'une décision peut être prise.

---

# Pourquoi nettoyer le firmware ?

Les constructeurs ajoutent généralement de nombreuses applications destinées à :

- la démonstration du produit ;
- les mises à jour OTA ;
- le diagnostic usine ;
- les fonctions de projection ;
- les services après-vente ;
- les outils internes.

Certaines sont indispensables.

D'autres ne sont jamais utilisées par l'utilisateur final.

Le nettoyage vise uniquement les composants dont la suppression ne dégrade pas les fonctionnalités souhaitées.

---

# Les différentes catégories d'applications

Durant notre étude, nous avons classé les APK en plusieurs catégories.

## Applications Android standard

Exemples :

- Settings
- Package Installer
- DocumentsUI
- Bluetooth

Ces composants sont conservés.

---

## Applications Rockchip

Exemples :

- RKDeviceTest
- composants matériels

Leur rôle doit être analysé avant toute modification.

---

## Applications constructeur

Exemples :

- TXCZ OTA
- Launcher OEM
- QuickShare
- USBDisplay

Chaque application est étudiée individuellement.

---

## Applications de diagnostic

Présentes principalement pour :

- les tests usine ;
- le contrôle qualité ;
- le SAV.

Ces applications peuvent parfois être supprimées sans impact sur l'utilisateur final, mais cette décision doit être validée expérimentalement.

---

# Méthodologie

Chaque application reçoit une fiche d'analyse.

---

## Exemple

### Nom

```
TXCZ OTA
```

### Emplacement

```
/system/priv-app/
```

### Permissions

Liste des permissions déclarées dans `AndroidManifest.xml`.

### Services

Services Android exportés.

### Receivers

Broadcast Receivers.

### Dépendances

Bibliothèques utilisées.

### Fonction

Description issue de l'analyse.

### Décision

```
Conserver

ou

Supprimer

ou

À étudier
```

---

# Outils utilisés

Pour chaque APK :

```bash
aapt dump badging

apktool d

jadx

apkanalyzer
```

Objectifs :

- extraire le manifeste ;
- identifier les composants ;
- comprendre les dépendances ;
- retrouver les appels JNI ;
- analyser les permissions.

---

# Vérification des dépendances

Avant toute suppression, nous recherchons :

- les appels Binder ;
- les Intents ;
- les Services ;
- les bibliothèques natives ;
- les propriétés Android utilisées.

Une application peut sembler inutile alors qu'elle initialise un composant essentiel au démarrage.

---

# Les méthodes de désactivation

Plusieurs approches sont possibles.

## Désactivation logique

L'application reste présente mais n'est plus lancée.

Avantage :

- totalement réversible.

---

## Déplacement

L'APK est déplacée hors de son répertoire d'origine.

Permet un retour arrière très simple.

---

## Suppression

L'APK est retirée de l'image système.

Cette méthode n'est utilisée qu'après validation complète.

---

# Validation

Après chaque modification, plusieurs tests sont réalisés.

## Démarrage

Le système démarre normalement.

---

## Interface

Le Launcher fonctionne.

---

## Projection

Les fonctions de projection restent opérationnelles.

---

## Réseau

Wi-Fi et Bluetooth fonctionnent.

---

## Keystone

La correction trapézoïdale est opérationnelle.

---

## Autofocus

Le comportement est inchangé.

---

# Journal des essais

Toutes les modifications sont consignées.

| Essai | Application  | Action             | Résultat     |
| ----: | ------------ | ------------------ | ------------ |
|  #001 | TXCZ OTA     | Désactivation      | À documenter |
|  #002 | RKDeviceTest | Déplacement        | À documenter |
|  #003 | QuickShare   | Analyse uniquement | En cours     |

Cette chronologie permettra de retracer précisément l'évolution du firmware.

---

# Critères de décision

Une application ne sera supprimée que si :

- son rôle est identifié ;
- aucune dépendance critique n'est observée ;
- les essais sont reproductibles ;
- les fonctions principales restent opérationnelles.

Dans tous les autres cas, l'application sera conservée jusqu'à obtention de nouvelles preuves.

---

# Documentation

Chaque suppression sera accompagnée :

- de la commande utilisée ;
- du SHA-256 de l'image modifiée ;
- des journaux système ;
- des captures d'écran éventuelles ;
- d'une justification.

L'objectif est que chaque décision puisse être auditée.

---

# Limites

L'absence d'effet visible après suppression d'une application ne prouve pas qu'elle est inutile.

Certaines fonctions peuvent n'être sollicitées que dans des conditions particulières :

- mise à jour OTA ;
- réinitialisation usine ;
- mode diagnostic ;
- projection spécifique.

Une période d'observation est donc nécessaire avant toute conclusion.

---

# Conclusion

Le nettoyage d'un firmware Android doit être réalisé avec méthode.

Chaque application retirée représente une hypothèse validée expérimentalement, et non une décision arbitraire.

Cette approche garantit que HY300 Ultimate restera stable tout en éliminant progressivement les composants réellement superflus.

---

> [!IMPORTANT]
> Ce chapitre décrit une méthodologie d'analyse et de validation. Les suppressions effectivement réalisées seront documentées individuellement, avec leurs résultats, afin que les lecteurs puissent distinguer les modifications confirmées des pistes encore en cours d'évaluation.

---

# Chapitre suivant

➡️ **41 – Intégration de Projectivy Launcher : remplacement du launcher constructeur et adaptation du système**