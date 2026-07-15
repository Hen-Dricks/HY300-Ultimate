---
title: "Dump complet des partitions"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 35 — Dump complet des partitions

> *« Avant de modifier un firmware, il faut être capable de le reconstruire intégralement. Cette reconstruction commence par une extraction complète des partitions. »*

---

# Introduction

Une fois la stratégie de sauvegarde définie, la première opération technique du projet HY300 Ultimate a consisté à extraire le contenu réel du projecteur.

Cette étape avait plusieurs objectifs :

- conserver une copie exacte du firmware ;
- documenter la disposition des partitions ;
- disposer d'images restaurables ;
- préparer les futures modifications.

Contrairement à de nombreux tutoriels qui proposent uniquement de télécharger une image officielle, notre objectif était de travailler directement à partir de l'appareil physique.

---

# Pourquoi extraire les partitions ?

Les fichiers OTA publiés par les constructeurs ne reflètent pas toujours exactement l'état du système installé.

Ils peuvent :

- être compressés ;
- être différentiels ;
- contenir des métadonnées supplémentaires ;
- être destinés uniquement au mécanisme de mise à jour.

En extrayant directement les partitions du projecteur, nous obtenons une photographie fidèle de son état réel.

---

# Prérequis

Avant toute extraction, plusieurs conditions devaient être réunies :

- accès ADB fonctionnel ;
- privilèges root (`adbd` lancé en root) ;
- espace de stockage suffisant ;
- possibilité de transférer les images vers un ordinateur.

Ces conditions ont été vérifiées lors des chapitres précédents.

---

# Découverte des partitions

La première étape consiste à identifier les partitions présentes sur le support eMMC.

Commande utilisée :

```bash
adb shell

ls -l /dev/block/by-name
```

Résultat observé :

```text
backup
baseparameter
boot
cache
cust
dtbo
logo
metadata
misc
recovery
security
super
trust
uboot
userdata
vbmeta
```

Cette cartographie confirme que le firmware est organisé selon un schéma classique pour une plateforme Rockchip.

---

# Pourquoi utiliser /dev/block/by-name ?

Android fournit plusieurs chemins vers les partitions.

Par exemple :

```
/dev/block/mmcblk2p15
```

ou

```
/dev/block/by-name/super
```

Nous avons systématiquement privilégié les liens symboliques présents dans `/dev/block/by-name`.

Ils sont :

- plus lisibles ;
- indépendants de la numérotation physique ;
- beaucoup moins susceptibles de changer entre deux versions du firmware.

---

# Extraction des partitions

Chaque partition a été copiée avec `dd`.

Exemple :

```bash
adb exec-out \
"dd if=/dev/block/by-name/boot bs=4M 2>/dev/null" \
> backup/partitions/boot.img
```

Le même principe a été appliqué à l'ensemble des partitions étudiées.

---

# Sauvegarde de la partition super

La partition `super` représente le cœur du système Android moderne.

Avant toute modification, elle a été :

- copiée intégralement ;
- transférée sur une carte microSD ;
- vérifiée par lecture complète ;
- validée par SHA-256.

Cette image servira de référence pendant tout le projet.

---

# Vérification des images

Chaque extraction est soumise à trois contrôles.

## Taille

La taille de l'image doit être identique à celle de la partition.

Exemple :

```bash
stat -c %s super.img
```

---

## Lecture complète

La fin du fichier est relue afin de vérifier que la copie n'est pas tronquée.

Exemple :

```bash
dd if=super.img bs=1M skip=2390 count=5
```

---

## Empreinte SHA-256

Toutes les images sont signées.

Exemple :

```bash
sha256sum super.img
```

Cette étape garantit que les futures comparaisons seront fiables.

---

# Les partitions effectivement sauvegardées

Au cours de cette étude, plusieurs partitions critiques ont été extraites.

Parmi elles :

| Partition | Objectif                   |
| --------- | -------------------------- |
| boot      | noyau Linux                |
| vbmeta    | Android Verified Boot      |
| super     | système Android            |
| misc      | configuration de démarrage |
| backup    | données constructeur       |
| cust      | personnalisation OEM       |

Les autres partitions pourront être extraites ultérieurement si nécessaire.

---

# Organisation des fichiers

Les images sont stockées dans :

```text
backup/

└── partitions/

    boot.img

    misc.img

    backup.img

    cust.img

    super.img

    vbmeta.img
```

Les empreintes sont regroupées dans :

```text
backup/hashes/
```

---

# Difficultés rencontrées

Plusieurs difficultés ont été observées.

## Taille importante de super

La partition `super` dépasse deux gigaoctets.

Son extraction nécessite :

- suffisamment d'espace libre ;
- une liaison ADB stable ;
- une vérification complète après transfert.

---

## Débit ADB

L'extraction est limitée par le débit USB et par les performances du stockage interne.

Le temps de copie peut dépasser plusieurs minutes.

---

## Validation

Une simple copie ne suffit pas.

Nous avons systématiquement :

- comparé les tailles ;
- relu la fin de l'image ;
- calculé une empreinte SHA-256.

Ces vérifications permettent d'éviter les erreurs silencieuses.

---

# Journal de développement

**Date :**

2026-07-14

**Objectif :**

Extraire les partitions critiques avant toute modification.

**Résultat :**

✓ Accès root confirmé.

✓ Partitions identifiées.

✓ Images sauvegardées.

✓ SHA-256 calculés.

✓ Intégrité validée.

**Décision :**

Les sauvegardes sont considérées comme la référence officielle du projet HY300 Ultimate.

Aucune modification ultérieure ne sera effectuée directement sur ces images.

---

# Conclusion

Cette étape marque le véritable début de la construction de la ROM personnalisée.

Grâce à ces sauvegardes, nous disposons désormais :

- d'un firmware de référence ;
- d'images restaurables ;
- d'une base fiable pour toutes les expérimentations futures.

Les chapitres suivants utiliseront exclusivement ces copies afin de préserver l'intégrité des données d'origine.

---

> [!TIP]
> Ne travaillez jamais directement sur une image extraite du matériel. Conservez toujours une copie de référence immuable et réalisez toutes vos expérimentations sur des duplicatas.