---
title: "fstab.rk30board : décryptage ligne par ligne"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 16 — `fstab.rk30board` : décryptage ligne par ligne

> *« Si Android sait où trouver ses partitions, c'est parce qu'un simple fichier texte lui indique exactement comment construire son système de fichiers. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre le rôle exact d'un `fstab` Android moderne ;
- interpréter chaque colonne d'une entrée `fstab` ;
- comprendre les options de montage utilisées par Android 12 ;
- expliquer les différences entre partitions physiques et logiques ;
- comprendre comment le HY300 construit son système de fichiers.

---

# Introduction

Pendant de nombreuses années, Linux utilisait un fichier appelé :

```
/etc/fstab
```

pour décrire les systèmes de fichiers à monter au démarrage.

Android reprend exactement ce principe.

Cependant, Android moderne possède plusieurs contraintes supplémentaires :

- partitions dynamiques ;
- chiffrement ;
- Verified Boot ;
- First Stage Mount ;
- volumes amovibles ;
- ZRAM.

Le fichier `fstab` Android est donc beaucoup plus riche que son équivalent Linux traditionnel.

Dans notre cas, nous avons extrait :

```
/vendor/etc/fstab.rk30board
```

Ce fichier constitue l'une des descriptions les plus précises du stockage interne du HY300.

---

# Le fichier complet

Pendant notre enquête, nous avons obtenu le contenu suivant :

```fstab
system      /system      ext4    ro,barrier=1      wait,logical,first_stage_mount
vendor      /vendor      ext4    ro,barrier=1      wait,logical,first_stage_mount
odm         /odm         ext4    ro,barrier=1      wait,logical,first_stage_mount

/dev/block/by-name/boot     /boot      emmc defaults first_stage_mount
/dev/block/by-name/cache    /cache     ext4 noatime,nodiratime,nosuid,nodev,noauto_da_alloc,discard wait,check
/dev/block/by-name/metadata /metadata  ext4 nodev,noatime,nosuid,discard,sync wait,formattable,first_stage_mount,check
/dev/block/by-name/misc     /misc      emmc defaults defaults

/devices/platform/*usb* auto vfat defaults voldmanaged=usb:auto
/devices/platform/*.sata* auto vfat defaults voldmanaged=sata:auto

/dev/block/zram0 none swap defaults zramsize=75%,max_comp_streams=8,zram_backingdev_size=256M

/dev/block/by-name/cust /cust ext4 noatime,nodiratime,nosuid,nodev,noauto_da_alloc,discard wait,check
/dev/block/by-name/logo /logo ext4 noatime,nodiratime,nosuid,nodev,noauto_da_alloc,discard wait,check

/devices/platform/ff370000.dwmmc/mmc_host* auto auto defaults voldmanaged=sdcard1:auto

/dev/block/by-name/userdata /data ext4 discard,noatime,nosuid,nodev,noauto_da_alloc,data=ordered,user_xattr,barrier=1 latemount,wait,formattable,check,fileencryption=software,quota,reservedsize=128M,checkpoint=block

system_ext /system_ext ext4 ro,barrier=1 wait,logical,first_stage_mount
vendor_dlkm /vendor_dlkm ext4 ro,barrier=1 wait,logical,first_stage_mount
odm_dlkm /odm_dlkm ext4 ro,barrier=1 wait,logical,first_stage_mount
product /product ext4 ro,barrier=1 wait,logical,first_stage_mount
```

---

# Anatomie d'une ligne

Prenons la première entrée.

```fstab
system /system ext4 ro,barrier=1 wait,logical,first_stage_mount
```

Elle se décompose en cinq champs.

```
Source

↓

Point de montage

↓

Système de fichiers

↓

Options Linux

↓

Options Android
```

Chaque champ possède une signification précise.

---

# Champ 1 : la source

```
system
```

Ici il ne s'agit **pas** d'une partition GPT.

Il s'agit d'une partition logique.

Android ira la rechercher dans :

```
super.img
```

grâce aux métadonnées LPMetadata.

Autrement dit :

```
system
```

n'existe pas physiquement.

Elle est créée dynamiquement au démarrage.

---

# Champ 2 : le point de montage

```
/system
```

Une fois montée,

la partition sera accessible ici :

```
/system/bin

/system/lib

/system/app
```

Toutes les applications Android utilisent ensuite ce chemin.

---

# Champ 3 : le système de fichiers

```
ext4
```

Android utilise ici :

```
Fourth Extended Filesystem
```

Ext4 reste aujourd'hui le système de fichiers dominant sur Android.

Ses principaux avantages sont :

- journalisation ;
- stabilité ;
- récupération après panne ;
- excellentes performances.

---

# Champ 4 : options Linux

```
ro

barrier=1
```

Ces options sont directement interprétées par le noyau Linux.

---

## ro

```
Read Only
```

La partition est montée en lecture seule.

Cette protection réduit les risques de corruption.

Elle explique également pourquoi une partition système ne peut pas être modifiée sans remonter le système en écriture ou reconstruire le firmware.

---

## barrier=1

Cette option active les barrières d'écriture du système de fichiers.

Avant de confirmer une écriture, Linux s'assure que les données ont réellement été enregistrées sur le stockage.

Cela améliore considérablement la résistance aux coupures d'alimentation.

Sur un appareil comme un projecteur, susceptible d'être éteint brutalement, ce choix est particulièrement pertinent.

---

# Champ 5 : options Android

```
wait

logical

first_stage_mount
```

Ces options ne sont pas destinées au noyau.

Elles sont interprétées par `init`.

---

## wait

Android attend que le périphérique soit disponible.

Sans cette option,

le démarrage pourrait continuer avant que la partition n'existe.

---

## logical

Cette option indique qu'il ne s'agit pas d'une partition GPT.

Android doit rechercher cette partition dans :

```
super.img
```

C'est cette simple option qui active toute la mécanique des Dynamic Partitions.

---

## first_stage_mount

Cette option est l'une des plus importantes.

Elle signifie :

```
Monter cette partition avant même que le Framework Android n'existe.
```

Ces partitions sont donc disponibles dès les premières secondes du démarrage.

Sans elles,

Android ne pourrait jamais lancer `init`.

---

# Les partitions physiques

Certaines lignes utilisent directement :

```
/dev/block/by-name/
```

Exemple :

```fstab
/dev/block/by-name/boot
```

Ici,

Android monte directement une partition GPT réelle.

Contrairement à :

```
system
```

celle-ci existe physiquement sur l'eMMC.

---

# Les périphériques USB

Une autre ligne attire immédiatement l'attention.

```fstab
/devices/platform/*usb*
```

Cette entrée indique au démon `vold` de surveiller automatiquement les périphériques USB.

Lorsqu'une clé est branchée,

Android crée dynamiquement un point de montage.

Cette configuration explique pourquoi notre projecteur reconnaît automatiquement les clés USB sans intervention de l'utilisateur.

---

# Les cartes microSD

Nous avons également identifié :

```fstab
/devices/platform/ff370000.dwmmc/mmc_host*
```

Cette ligne est particulièrement intéressante.

Elle correspond exactement au lecteur microSD intégré.

Lors de nos essais,

nous avons inséré une carte SD.

Android l'a immédiatement détectée.

Les commandes suivantes l'ont confirmé :

```bash
df -h

mount
```

Résultat observé :

```text
/dev/block/vold/public:179,97
```

La carte était montée automatiquement en :

```
vfat
```

Cette observation valide directement la configuration décrite par `fstab`.

---

# userdata

La ligne suivante mérite une attention particulière.

```fstab
fileencryption=software
```

Nous avons ici une information très importante.

Le HY300 utilise :

```
Software File Encryption
```

et non un chiffrement matériel dédié.

Cette distinction pourra avoir des implications en matière de performances et de sécurité.

Toutefois, nous n'avons pas cherché à mesurer expérimentalement cet impact durant cette étude.

---

# quota

L'option :

```
quota
```

active la gestion des quotas disque.

Android peut ainsi limiter la consommation d'espace par certains utilisateurs ou services.

---

# reservedsize

```
reservedsize=128M
```

Le système réserve :

```
128 Mo
```

afin d'éviter une saturation complète de la partition.

Même lorsqu'il reste très peu d'espace libre,

Android conserve ainsi une marge permettant de poursuivre certaines opérations critiques.

---

# checkpoint

```
checkpoint=block
```

Cette option est utilisée lors des mises à jour.

Elle permet de revenir à un état cohérent si une opération est interrompue brutalement.

---

# Les volumes amovibles

Grâce à ce fichier,

nous avons confirmé que le HY300 supporte :

- USB
- SATA
- microSD

sans configuration supplémentaire.

Tout est pris en charge automatiquement par `vold`.

---

# Ce que nous avons appris

L'analyse de `fstab.rk30board` montre que le constructeur s'appuie largement sur les mécanismes modernes d'Android :

- First Stage Mount ;
- Dynamic Partitions ;
- ext4 ;
- Software File Encryption ;
- ZRAM ;
- gestion automatique des périphériques amovibles.

Les personnalisations observées concernent principalement les chemins de montage et certains paramètres propres au matériel Rockchip, tandis que la structure générale reste conforme aux recommandations d'AOSP.

---

# Résumé

Ce fichier, pourtant composé de quelques dizaines de lignes, décrit l'organisation complète du stockage du HY300.

Il relie :

- le noyau Linux ;
- les partitions dynamiques ;
- les périphériques USB ;
- la microSD ;
- le chiffrement ;
- la mémoire compressée ;
- les mécanismes de récupération.

Comprendre `fstab` revient à comprendre comment Android construit progressivement son propre système de fichiers.

---

> [!IMPORTANT]
> `fstab.rk30board` est l'un des fichiers les plus stratégiques du firmware. Une modification incorrecte peut empêcher le montage des partitions essentielles et bloquer complètement le démarrage du système.

---

# Chapitre suivant

➡️ **17 – ZRAM, mémoire compressée et gestion de la RAM sur le HY300**