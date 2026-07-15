---
title: "Cartographie complète des partitions"
author: "HY300 Ultimate Research"
version: "1.0"
language: "fr"
status: "Draft"
last_updated: "2026-07-14"
---

# Chapitre 12 — Cartographie complète des partitions

> *« Le firmware n'est pas un simple fichier. C'est un disque complet organisé en partitions, chacune ayant une responsabilité bien précise. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre l'organisation complète du stockage eMMC du HY300 ;
- connaître le rôle exact de chaque partition ;
- identifier les partitions critiques ;
- distinguer les partitions Android des partitions Rockchip ;
- savoir quelles partitions peuvent être sauvegardées ou modifiées en toute sécurité.

---

# Introduction

Avant de modifier un firmware Android, une question fondamentale doit être résolue :

**Comment le stockage est-il organisé ?**

La réponse ne consiste pas seulement à connaître l'existence d'une partition `system`.

Un appareil Android moderne repose sur plusieurs dizaines de partitions, chacune ayant une fonction spécifique.

Certaines contiennent du code.

D'autres stockent des paramètres.

Certaines sont indispensables au démarrage.

D'autres servent uniquement aux mises à jour.

Une erreur sur une seule partition peut empêcher complètement le démarrage de l'appareil.

C'est pourquoi nous avons commencé notre enquête par une cartographie exhaustive du stockage.

---

# Découverte des partitions

Grâce à l'accès root obtenu via ADB, nous avons demandé directement au noyau Linux la liste des partitions présentes.

Commande utilisée :

```bash
adb shell

ls -l /dev/block/by-name
```

Résultat observé :

```text
backup      -> /dev/block/mmcblk2p9
baseparameter -> /dev/block/mmcblk2p13
boot        -> /dev/block/mmcblk2p7
cache       -> /dev/block/mmcblk2p10
cust        -> /dev/block/mmcblk2p14
dtbo        -> /dev/block/mmcblk2p5
logo        -> /dev/block/mmcblk2p12
metadata    -> /dev/block/mmcblk2p11
misc        -> /dev/block/mmcblk2p4
recovery    -> /dev/block/mmcblk2p8
security    -> /dev/block/mmcblk2p1
super       -> /dev/block/mmcblk2p15
trust       -> /dev/block/mmcblk2p3
uboot       -> /dev/block/mmcblk2p2
userdata    -> /dev/block/mmcblk2p16
vbmeta      -> /dev/block/mmcblk2p6
```

Cette sortie constitue la première représentation fidèle de l'organisation interne du projecteur.

Contrairement à de nombreux guides publiés sur Internet, elle ne provient pas d'une documentation constructeur mais directement de l'appareil étudié.

---

# Représentation graphique

L'organisation peut être représentée ainsi :

```text
eMMC (mmcblk2)

├── p1   security
├── p2   uboot
├── p3   trust
├── p4   misc
├── p5   dtbo
├── p6   vbmeta
├── p7   boot
├── p8   recovery
├── p9   backup
├── p10  cache
├── p11  metadata
├── p12  logo
├── p13  baseparameter
├── p14  cust
├── p15  super
└── p16  userdata
```

Cette représentation sera utilisée dans tous les chapitres suivants.

---

# Les partitions de démarrage

Plusieurs partitions sont directement impliquées dans la chaîne de démarrage.

## security

Très peu documentée publiquement.

Elle contient généralement des informations spécifiques au constructeur ou à la plateforme Rockchip.

Toute modification doit être évitée.

---

## uboot

Contient le chargeur d'amorçage principal.

Sans lui, Linux ne peut pas être lancé.

Une corruption de cette partition empêche généralement tout démarrage normal.

---

## trust

Contient le firmware du Trusted Execution Environment (TEE).

Il intervient dans les fonctions de sécurité de bas niveau.

Cette partition est spécifique à l'architecture Rockchip.

---

## misc

Cette partition est particulièrement importante.

Elle stocke notamment :

- les demandes de démarrage en recovery ;
- certaines informations de Bootloader Control Block (BCB) ;
- différents paramètres temporaires.

Nous l'avons sauvegardée intégralement avant toute expérimentation.

---

# Les partitions liées au noyau

## dtbo

Cette partition contient les Device Tree Overlays.

Elle permet au noyau Linux d'adapter sa configuration au matériel.

---

## vbmeta

`vbmeta` est le cœur d'Android Verified Boot (AVB).

Son rôle est de garantir l'intégrité des partitions protégées.

Une modification incorrecte peut entraîner un refus de démarrage sur certains appareils.

Le comportement exact du HY300 sera étudié dans un chapitre dédié.

---

## boot

Cette partition contient :

- le noyau Linux ;
- le ramdisk initial ;
- les paramètres de démarrage.

Elle représente le point d'entrée d'Android.

---

## recovery

Cette partition contient l'environnement Recovery.

Notre étude a confirmé son bon fonctionnement.

Nous avons également identifié plusieurs mécanismes destinés à maintenir ou restaurer son contenu (`install-recovery.sh`, `recovery-from-boot.p`), qui seront analysés plus loin.

---

# Les partitions système

## super

Il s'agit de la partition la plus volumineuse et de la plus importante.

Elle ne contient pas directement Android.

Elle contient plusieurs partitions logiques :

- system
- vendor
- odm
- product
- system_ext
- vendor_dlkm
- odm_dlkm

Elle fera l'objet de plusieurs chapitres spécifiques.

---

## userdata

Cette partition contient les données utilisateur :

- applications installées ;
- paramètres ;
- fichiers personnels ;
- caches applicatifs.

Elle n'intervient pas directement dans le démarrage du système.

---

# Les partitions spécifiques au constructeur

Certaines partitions sont absentes de la plupart des smartphones Android.

Leur présence traduit des choix propres à cette plateforme.

## backup

Le nom suggère un espace réservé à des sauvegardes ou à des mécanismes de récupération.

Nous avons choisi de la sauvegarder intégralement avant toute modification afin de préserver son contenu pour une analyse ultérieure.

---

## baseparameter

Cette partition semble contenir des paramètres matériels ou d'affichage.

Son rôle exact reste à confirmer.

Compte tenu de son nom et de la nature de l'appareil, il est plausible qu'elle participe à la configuration de la sortie vidéo ou de certains réglages spécifiques au projecteur.

Cette hypothèse devra être validée par une analyse de son contenu.

---

## logo

Comme sur de nombreux appareils Android, cette partition contient les éléments graphiques affichés pendant le démarrage (logo constructeur, écran de boot, etc.).

---

## cust

Le nom « cust » est généralement associé à des personnalisations constructeur.

Selon les plateformes, cette partition peut contenir :

- ressources graphiques ;
- fichiers de configuration ;
- applications additionnelles ;
- paramètres régionaux.

Nous l'avons sauvegardée avant toute expérimentation.

---

## cache

Historiquement utilisée pour les mises à jour OTA et certains fichiers temporaires.

Son importance est aujourd'hui plus limitée sur Android récent, mais elle reste présente sur le HY300.

---

## metadata

Introduite avec les versions récentes d'Android, cette partition stocke différentes métadonnées nécessaires au système.

Elle est notamment utilisée par :

- le chiffrement ;
- les checkpoints ;
- certains mécanismes de montage.

---

# Sauvegarde avant expérimentation

Conformément à la méthodologie définie dans le premier volume, plusieurs partitions ont été sauvegardées avant toute opération d'écriture.

Parmi elles :

- `misc`
- `backup`
- `cust`
- `super`

Chaque image a ensuite été vérifiée par empreinte SHA-256 afin de garantir son intégrité.

Cette précaution permettra, si nécessaire, de restaurer exactement l'état initial du projecteur.

---

# Classification des partitions

Le tableau suivant résume leur niveau de criticité.

| Partition     | Fonction principale           | Criticité     |
| ------------- | ----------------------------- | ------------- |
| security      | Sécurité plateforme           | 🔴 Très élevée |
| uboot         | Chargeur d'amorçage           | 🔴 Très élevée |
| trust         | TEE                           | 🔴 Très élevée |
| misc          | Paramètres de démarrage       | 🟠 Élevée      |
| dtbo          | Configuration matérielle      | 🟠 Élevée      |
| vbmeta        | Android Verified Boot         | 🔴 Très élevée |
| boot          | Noyau Linux                   | 🔴 Très élevée |
| recovery      | Environnement de récupération | 🟠 Élevée      |
| backup        | Sauvegarde constructeur       | 🟡 Moyenne     |
| cache         | Cache système                 | 🟢 Faible      |
| metadata      | Métadonnées Android           | 🟠 Élevée      |
| logo          | Écran de démarrage            | 🟢 Faible      |
| baseparameter | Paramètres constructeur       | 🟠 Élevée      |
| cust          | Personnalisation OEM          | 🟡 Moyenne     |
| super         | Système Android               | 🔴 Critique    |
| userdata      | Données utilisateur           | 🟢 Variable    |

---

# Ce que notre étude confirme

Les observations réalisées montrent que le HY300 adopte une organisation hybride.

D'une part, il reprend les mécanismes modernes d'Android 12 (partitions dynamiques, `vbmeta`, `metadata`, `super`).

D'autre part, il conserve plusieurs partitions spécifiques à l'écosystème Rockchip (`trust`, `baseparameter`, `backup`), qui témoignent de l'intégration profonde réalisée par le constructeur.

Cette combinaison est typique des appareils Android embarqués et explique pourquoi une compréhension du matériel sous-jacent est indispensable avant toute modification du firmware.

---

> [!IMPORTANT]
> La présence d'une partition dans `/dev/block/by-name` ne signifie pas qu'elle peut être modifiée sans conséquence. Certaines partitions sont directement impliquées dans la chaîne de démarrage ou les mécanismes de sécurité et doivent être manipulées avec une extrême prudence.

---

## Chapitre suivant

➡️ **13 – Les partitions dynamiques : anatomie de `super.img`**