---
title: "Recovery, Fastboot et interfaces USB"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 49 — Recovery, Fastboot et interfaces USB

> *« Avant de modifier un firmware, il faut comprendre comment le restaurer. La capacité à récupérer un appareil est aussi importante que la capacité à le modifier. »*

---

# Résumé exécutif

Ce chapitre étudie les mécanismes de maintenance et de récupération du vidéoprojecteur HY300.

L'objectif n'est pas uniquement d'identifier les différents modes de démarrage disponibles, mais également de comprendre :

- quelles interfaces sont réellement accessibles ;
- lesquelles sont destinées au constructeur ;
- quelles possibilités de récupération existent en cas d'échec du démarrage.

Au cours de cette étude, nous avons distingué les mécanismes confirmés de ceux qui restent à investiguer.

---

# Pourquoi étudier les modes de récupération ?

Toute expérimentation sur un firmware comporte un risque.

Une image incorrecte peut entraîner :

- un démarrage impossible ;
- une boucle de redémarrage ;
- une perte d'accès ADB ;
- un système partiellement fonctionnel.

Avant toute modification, il est donc indispensable de connaître les méthodes permettant de récupérer l'appareil.

---

# Les interfaces étudiées

L'analyse porte sur plusieurs niveaux.

## USB

Interface physique principale.

Elle permet notamment :

- alimentation (selon le modèle) ;
- périphériques de stockage ;
- clavier et souris ;
- communication ADB lorsque celle-ci est activée.

---

## ADB

ADB constitue l'interface principale utilisée pendant cette étude.

Elle a permis :

- l'inventaire du système ;
- l'extraction des partitions ;
- l'analyse dynamique ;
- la collecte des journaux.

L'accès ADB a été obtenu dans un contexte de test contrôlé.

---

## Recovery Android

Le firmware contient une partition `recovery`.

Cette partition est généralement utilisée pour :

- les mises à jour locales ;
- les réinitialisations d'usine ;
- certaines opérations de maintenance.

Au moment de cette rédaction, son comportement exact sur ce modèle reste à documenter plus précisément.

---

## Fastboot

Fastboot est présent sur de nombreux appareils Android.

Toutefois, sa présence dépend :

- du chargeur de démarrage ;
- de la configuration du constructeur ;
- de la plateforme matérielle.

Dans le cadre de cette étude, aucune conclusion n'est tirée tant que ce mode n'a pas été observé et caractérisé.

---

## Modes spécifiques Rockchip

Les plateformes Rockchip disposent souvent de mécanismes de récupération supplémentaires.

Selon les modèles, ceux-ci peuvent inclure des modes destinés à :

- la programmation en usine ;
- la récupération après corruption du firmware ;
- le développement.

Leur disponibilité dépend du matériel et du firmware.

Ils feront l'objet d'analyses spécifiques lorsqu'ils seront observés.

---

# Chaîne de récupération

Le processus de maintenance peut être représenté ainsi.

```text
Boot normal

↓

Échec

↓

Recovery

↓

Maintenance

↓

Flash

↓

Redémarrage
```

Selon la plateforme, des modes intermédiaires peuvent exister.

---

# Interfaces USB

Pendant notre étude, plusieurs usages de l'USB ont été identifiés.

## Stockage

Lecture de supports externes.

---

## Débogage

ADB.

---

## Mise à jour

Chargement éventuel de packages OTA.

---

## Maintenance

À confirmer selon le comportement observé du firmware.

---

# Scénarios étudiés

Nous distinguons plusieurs cas.

## Cas 1

Le système démarre normalement.

ADB est disponible.

Les opérations de maintenance sont simples.

---

## Cas 2

Android ne démarre plus.

Le Recovery reste accessible.

La restauration est potentiellement possible.

---

## Cas 3

Le Recovery est indisponible.

Un mode de récupération de plus bas niveau devient nécessaire.

---

## Cas 4

Plus aucun mode logiciel n'est accessible.

Une intervention matérielle ou spécifique au SoC peut être requise.

Ce scénario n'a pas été rencontré au cours de cette étude.

---

# Analyse de la sécurité

Les interfaces de maintenance représentent également une surface d'attaque.

L'audit porte notamment sur :

- l'authentification ADB ;
- l'exposition des interfaces USB ;
- les protections du Recovery ;
- les mécanismes empêchant les modifications non autorisées.

L'objectif est de comprendre le niveau de protection du firmware sans supposer l'existence de vulnérabilités.

---

# Tableau d'observation

| Interface                |  Observée   |    Testée     | Statut                   |
| ------------------------ | :---------: | :-----------: | ------------------------ |
| USB                      |      ✓      |       ✓       | Fonctionnelle            |
| ADB                      |      ✓      |       ✓       | Utilisée pendant l'étude |
| Recovery                 |      ✓      | Partiellement | Analyse en cours         |
| Fastboot                 | À confirmer |      Non      | À documenter             |
| Mode Rockchip spécifique | À confirmer |      Non      | À documenter             |

---

# Bonnes pratiques

Avant toute expérimentation :

- sauvegarder les partitions critiques ;
- conserver une copie du firmware d'origine ;
- documenter les commandes utilisées ;
- vérifier l'intégrité des images ;
- identifier les méthodes de récupération disponibles.

Ces précautions réduisent fortement le risque de perte de l'appareil.

---

# Journal de développement

**Objectif**

Identifier les mécanismes de récupération disponibles sur le HY300.

**Résultat**

ADB a constitué l'interface principale de travail.

Les autres modes de récupération feront l'objet d'analyses complémentaires à mesure des expérimentations.

---

# Enseignements

La récupération d'un appareil Android ne repose pas sur un unique mécanisme.

Selon le contexte, plusieurs couches peuvent intervenir :

- Android lui-même ;
- Recovery ;
- chargeur de démarrage ;
- mécanismes spécifiques au fabricant du SoC.

Comprendre cette hiérarchie est indispensable avant toute modification profonde du firmware.

---

# Conclusion

Les interfaces de maintenance ne sont pas uniquement des outils de développement.

Elles représentent également les mécanismes qui permettent de restaurer un appareil après une expérimentation ou une mise à jour défaillante.

Dans le cadre de HY300 Ultimate, leur étude fait partie intégrante de la stratégie de développement responsable, où chaque modification doit pouvoir être annulée et chaque expérimentation doit rester réversible.

---

> [!IMPORTANT]
> Ce chapitre décrit les mécanismes de récupération observés et les pistes d'analyse retenues. Il ne doit pas être interprété comme une preuve que tous les modes de maintenance sont présents ou accessibles sur ce modèle. Chaque affirmation sera complétée ou corrigée au fur et à mesure des observations expérimentales.

---

# Chapitre suivant

➡️ **50 – OTA et certificats : analyse des mécanismes de mise à jour et de confiance**