---
title: "Intégration de Projectivy Launcher"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 41 — Intégration de Projectivy Launcher

> *« Le launcher est la première chose que voit l'utilisateur. Il influence directement la perception des performances, de la stabilité et de la qualité d'un firmware. »*

---

# Introduction

L'un des objectifs majeurs de HY300 Ultimate est d'améliorer l'expérience utilisateur sans modifier profondément Android.

Le launcher constructeur remplit correctement son rôle, mais il présente plusieurs limites :

- interface peu moderne ;
- animations limitées ;
- manque de personnalisation ;
- raccourcis parfois peu intuitifs ;
- dépendance à plusieurs composants OEM.

Après plusieurs comparaisons, **Projectivy Launcher** a été retenu comme base de travail.

---

# Pourquoi Projectivy ?

Plusieurs launchers Android TV ont été évalués.

Les principaux critères étaient :

- rapidité ;
- stabilité ;
- compatibilité Android 11 ;
- personnalisation ;
- absence de publicité ;
- développement actif.

Projectivy répondait à l'ensemble de ces critères.

---

# Les alternatives étudiées

Avant de faire ce choix, plusieurs solutions ont été analysées.

| Launcher          | Évaluation                                   |
| ----------------- | -------------------------------------------- |
| Launcher OEM      | Fonctionnel mais limité                      |
| Projectivy        | Retenu                                       |
| FLauncher         | Très léger mais moins adapté aux projecteurs |
| ATV Launcher      | Interface moderne                            |
| Wolf Launcher     | Développement arrêté                         |
| Leanback Launcher | Référence AOSP mais peu personnalisable      |

Le choix de Projectivy résulte d'un compromis entre simplicité, fonctionnalités et stabilité.

---

# Objectifs de l'intégration

Le remplacement du launcher ne doit pas modifier le comportement du matériel.

Les objectifs sont donc :

- conserver Keystone ;
- conserver l'autofocus ;
- conserver les raccourcis système ;
- améliorer la navigation ;
- accélérer l'accès aux applications.

---

# Architecture

Le launcher est une application Android classique.

```
Boot

↓

System Server

↓

PackageManager

↓

Launcher

↓

Interface utilisateur
```

Le remplacement ne modifie donc pas directement les couches basses du système.

---

# Préparation

Avant toute modification :

- sauvegarde de l'APK constructeur ;
- sauvegarde des permissions ;
- sauvegarde des intents déclarés ;
- vérification des dépendances.

Cette étape garantit un retour arrière rapide.

---

# Installation

Plusieurs approches sont possibles.

## Installation comme application utilisateur

Simple mais non persistante après réinitialisation.

---

## Installation comme application système

L'APK est intégrée dans :

```
/system/priv-app/
```

Cette méthode est retenue pour HY300 Ultimate.

---

# Définition du launcher par défaut

Android identifie le launcher grâce à un filtre d'intention.

Exemple :

```xml
<intent-filter>

<action android:name="android.intent.action.MAIN"/>

<category android:name="android.intent.category.HOME"/>

<category android:name="android.intent.category.DEFAULT"/>

</intent-filter>
```

Projectivy doit déclarer ces filtres pour être reconnu comme écran d'accueil.

---

# Gestion des raccourcis

Le launcher doit permettre un accès rapide :

- Paramètres Android ;
- Keystone ;
- Sélection de la source ;
- Gestion réseau ;
- Gestion Bluetooth.

Ces raccourcis seront adaptés si nécessaire.

---

# Compatibilité avec les fonctions OEM

Un point essentiel de cette intégration consiste à vérifier que les services spécifiques du projecteur restent accessibles.

Par exemple :

- correction trapézoïdale ;
- autofocus ;
- sélection HDMI ;
- projection sans fil.

Le launcher ne doit pas empêcher leur utilisation.

---

# Tests réalisés

Chaque version sera soumise aux essais suivants :

- démarrage à froid ;
- sortie de veille ;
- changement de langue ;
- rotation de l'affichage (si applicable) ;
- ouverture des paramètres ;
- lancement des applications système.

Les résultats seront documentés.

---

# Performances

Les indicateurs suivants seront comparés :

| Indicateur         | OEM       | Projectivy |
| ------------------ | --------- | ---------- |
| Temps de démarrage | À mesurer | À mesurer  |
| Occupation mémoire | À mesurer | À mesurer  |
| Fluidité           | À mesurer | À mesurer  |
| Réactivité         | À mesurer | À mesurer  |

Ces mesures permettront d'évaluer objectivement le bénéfice du changement.

---

# Retour arrière

En cas de problème, le launcher constructeur peut être restauré en réinstallant son APK système ou en rétablissant l'image système d'origine.

Cette possibilité est intégrée dès la conception de HY300 Ultimate.

---

# Journal de développement

**Date :**

2026-07-14

**Objectif :**

Remplacer le launcher constructeur par Projectivy Launcher.

**Résultat :**

En cours de validation.

**Points à vérifier :**

- démarrage automatique ;
- compatibilité avec les fonctions OEM ;
- stabilité à long terme ;
- consommation mémoire.

---

# Conclusion

Le remplacement du launcher constitue l'une des évolutions les plus visibles de HY300 Ultimate.

En choisissant Projectivy Launcher, le projet cherche avant tout à améliorer l'expérience utilisateur tout en conservant les fonctionnalités qui font la spécificité du projecteur.

Comme pour toutes les modifications de cette ROM, cette intégration sera validée par des essais reproductibles avant d'être considérée comme définitive.

---

> [!IMPORTANT]
> Le remplacement d'un launcher n'est pas seulement une modification esthétique. Il influence le processus de démarrage, la gestion des intents, l'expérience utilisateur et les interactions avec les applications système. Toute intégration doit donc être testée de manière approfondie avant d'être adoptée.