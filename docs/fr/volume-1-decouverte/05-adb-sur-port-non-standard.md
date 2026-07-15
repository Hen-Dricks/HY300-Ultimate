---
title: "ADB sur un port non standard"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 5 — ADB sur un port non standard

> *« Découvrir un port ouvert n'est qu'une étape. Comprendre ce qui se cache derrière est le véritable début de l'enquête. »*

---

# Introduction

Le chapitre précédent s'est terminé sur une découverte inattendue.

Alors que toutes nos hypothèses convergeaient vers le port TCP 5555, le projecteur exposait en réalité un service sur le port **3268**.

Nmap proposait une identification prudente : `globalcatLDAP?`.

Une simple tentative de connexion ADB allait pourtant démontrer qu'il ne s'agissait pas d'un service LDAP mais bien du démon **Android Debug Bridge**.

Cette découverte soulevait immédiatement plusieurs questions.

Pourquoi utiliser un port inhabituel ?

Le démon ADB disposait-il des mêmes privilèges qu'un appareil Android classique ?

Était-il limité à certaines commandes ?

Ou, au contraire, avions-nous obtenu un accès beaucoup plus puissant que prévu ?

Avant d'aller plus loin, il fallait caractériser précisément cet accès.

---

# Première connexion

La première étape consistait à vérifier que le démon répondait réellement au protocole ADB.

La commande utilisée fut volontairement simple.

```bash
adb connect 192.168.1.100:3268
```

> **Note:** L'adresse IP et le port montrés ici sont des valeurs d'exemple.
> Dans la pratique, l'adresse locale du projecteur dépend de votre réseau.

Le résultat fut immédiat.

```text
connected to 192.168.1.100:3268
```

Cette réponse est extrêmement importante.

ADB ne réalise pas simplement une connexion TCP.

Le client établit un dialogue spécifique avec le démon `adbd`.

Recevoir ce message signifie que le service distant implémente correctement le protocole Android Debug Bridge.

Autrement dit, il ne s'agit pas d'un faux positif de Nmap.

Le projecteur expose bien une interface ADB fonctionnelle.

---

# Pourquoi cette découverte est inhabituelle

Depuis Android 4.x, Google recommande que le débogage ADB soit désactivé par défaut sur les appareils destinés au grand public.

Lorsqu'il est activé, il écoute traditionnellement sur le port **5555**.

Dans notre cas, plusieurs éléments diffèrent de ce comportement standard.

- le port utilisé est **3268** ;
- aucune documentation constructeur ne mentionne cette configuration ;
- le service est accessible sans avoir à modifier le firmware.

Cette combinaison est suffisamment rare pour justifier une étude approfondie.

---

# L'étape suivante : évaluer les privilèges

Disposer d'un shell ADB n'implique pas automatiquement disposer de privilèges élevés.

Sur la plupart des smartphones commerciaux, la commande suivante échoue.

```bash
adb root
```

Le démon redémarre alors avec un message similaire à :

```text
adbd cannot run as root in production builds
```

Cette protection est volontaire.

Elle empêche un utilisateur disposant d'ADB d'obtenir directement les privilèges du superutilisateur.

Nous voulions donc savoir si le HY300 appliquait cette même politique.

---

# Une réponse inattendue

La commande exécutée fut la suivante.

```bash
adb root
```

Le résultat obtenu fut :

```text
restarting adbd as root
```

Cette simple ligne modifie complètement la nature de notre accès.

Le démon ne refuse pas l'opération.

Il redémarre explicitement avec les privilèges root.

Autrement dit, le constructeur n'a pas conservé le comportement restrictif habituellement rencontré sur les builds Android de production.

---

# Pourquoi cette différence est importante

Le démon `adbd` constitue la porte d'entrée privilégiée vers le système Android.

Lorsqu'il fonctionne avec les privilèges root, il devient possible d'effectuer directement des opérations normalement réservées au système.

Par exemple :

- lire les partitions bloc ;
- sauvegarder le firmware ;
- accéder aux répertoires système ;
- examiner les fichiers de configuration ;
- récupérer les APK système ;
- analyser les bibliothèques natives.

Cette capacité est précisément ce qui rendra possible les chapitres consacrés au reverse engineering du firmware.

---

# Vérifier les privilèges obtenus

Après le redémarrage du démon, plusieurs commandes de contrôle ont été exécutées.

L'objectif n'était pas encore de modifier le système.

Nous souhaitions simplement caractériser l'environnement dans lequel nous venions d'entrer.

Les premières commandes concernaient notamment :

- l'identité du processus courant ;
- les propriétés Android ;
- les points de montage ;
- les partitions visibles ;
- les services actifs.

Cette étape peut sembler anodine.

En réalité, elle constitue la première photographie complète du système avant toute modification.

Dans une démarche scientifique, cet instant est précieux.

Il représente l'état de référence à partir duquel toutes les expériences ultérieures pourront être comparées.

---

# Une règle méthodologique

À partir de ce moment précis, une décision importante fut prise.

Aucune modification permanente ne serait réalisée tant que nous ne disposerions pas d'une sauvegarde complète des partitions critiques.

Cette règle a guidé toute la suite du projet.

Avant chaque manipulation importante :

1. observer ;
2. documenter ;
3. sauvegarder ;
4. vérifier ;
5. seulement ensuite modifier.

Cette discipline explique pourquoi il a été possible de reconstruire le firmware tout en conservant un état de référence fiable.

---

# Ce que nous savons désormais

## Faits

Les observations réalisées dans ce chapitre permettent d'établir plusieurs faits.

- Le démon ADB est accessible sur le port TCP 3268.
- La commande `adb connect` fonctionne correctement.
- La commande `adb root` est acceptée.
- `adbd` redémarre effectivement avec les privilèges root.

Ces éléments ont été reproduits plusieurs fois au cours de l'étude.

## Déductions

L'appareil offre un niveau d'accès inhabituellement élevé pour un produit destiné au grand public.

Cet accès constitue un avantage considérable pour l'analyse du firmware.

Il réduit fortement la nécessité d'utiliser des méthodes matérielles plus intrusives telles que l'UART ou le mode Loader Rockchip.

## Hypothèses

À ce stade, plusieurs questions demeurent ouvertes.

Pourquoi le constructeur a-t-il conservé cette possibilité ?

S'agit-il d'une configuration de développement oubliée avant la mise en production ?

Ou bien d'un mécanisme volontaire destiné au support technique ?

Les chapitres suivants apporteront progressivement des éléments de réponse.

---

# Conclusion

Découvrir un démon ADB sur un port inattendu constituait déjà une découverte intéressante.

Constater que ce démon pouvait être redémarré directement avec les privilèges root change complètement la portée de cette étude.

Nous ne sommes plus simplement capables de dialoguer avec Android.

Nous sommes désormais en mesure d'observer le système dans son intégralité, de sauvegarder ses partitions et d'analyser son fonctionnement sans recourir à des techniques d'exploitation.

Le chapitre suivant sera consacré à la première cartographie systématique du système Android.

À partir des commandes les plus élémentaires, nous commencerons à dresser un inventaire précis des propriétés, des partitions, des services et des composants qui constituent le firmware du HY300.

---

> [!IMPORTANT]
> Les manipulations décrites dans ce chapitre ont été réalisées uniquement après validation de l'accès ADB et sans modification permanente du firmware. Les sauvegardes complètes des partitions seront présentées avant toute opération susceptible d'altérer le système.