---
title: "Annexe B — Commandes de manipulation des partitions"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "fr"
last_updated: "2026-07-14"
---

# Annexe B — Commandes de manipulation des partitions

> *« Comprendre les partitions Android est la première étape avant toute modification d'un firmware. »*

---

# Objectif

Cette annexe rassemble les principales commandes utilisées pour :

- identifier les partitions ;
- extraire les images ;
- monter les systèmes de fichiers ;
- vérifier leur intégrité ;
- reconstruire les partitions dynamiques.

Toutes les commandes présentées ont été sélectionnées pour leur utilité dans un projet de reverse engineering Android.

---

# Identifier les partitions

Lister les périphériques de blocs.

```bash
lsblk
```

Afficher les UUID.

```bash
blkid
```

Lister les partitions Android.

```bash
cat /proc/partitions
```

Lister les périphériques block.

```bash
ls -l /dev/block
```

---

# Informations système

Table de montage.

```bash
mount
```

Points de montage.

```bash
cat /proc/mounts
```

Utilisation disque.

```bash
df -h
```

Informations détaillées.

```bash
findmnt
```

---

# Examiner une image

Identifier un fichier.

```bash
file system.img
```

Informations générales.

```bash
stat system.img
```

Calcul de l'empreinte.

```bash
sha256sum system.img
```

---

# Conversion Sparse ↔ Raw

Sparse vers Raw.

```bash
simg2img system.img system.raw.img
```

Raw vers Sparse.

```bash
img2simg system.raw.img system.img
```

Ces conversions sont indispensables pour manipuler certaines images Android.

---

# Monter une image ext4

Créer le point de montage.

```bash
mkdir mount_system
```

Montage.

```bash
sudo mount -o loop system.raw.img mount_system
```

Démontage.

```bash
sudo umount mount_system
```

---

# Vérifier une image ext4

Contrôle.

```bash
e2fsck -f system.raw.img
```

Réparation automatique.

```bash
e2fsck -fy system.raw.img
```

Informations détaillées.

```bash
dumpe2fs system.raw.img
```

Informations du superbloc.

```bash
tune2fs -l system.raw.img
```

---

# Redimensionnement

Vérifier.

```bash
resize2fs -P system.raw.img
```

Réduire.

```bash
resize2fs system.raw.img 3500M
```

Agrandir.

```bash
resize2fs system.raw.img
```

Toujours exécuter `e2fsck` avant un redimensionnement.

---

# Partitions dynamiques

Extraire.

```bash
lpunpack super.img extracted/
```

Lister.

```bash
lpdump super.img
```

Reconstruire.

```bash
lpmake ...
```

Les paramètres exacts de `lpmake` dépendent du layout étudié.

---

# Vérifier les partitions LP

Informations.

```bash
lpdump super.img
```

Métadonnées.

```bash
lpdump --slot=all super.img
```

---

# Images boot

Décompresser.

```bash
unpack_bootimg.py
```

Reconstruction.

```bash
mkbootimg
```

Ces commandes sont utilisées pour les partitions de démarrage Android.

---

# Comparaison de fichiers

Comparaison binaire.

```bash
cmp fichier1 fichier2
```

Différences.

```bash
diff -ruN dossier1 dossier2
```

Hexadécimal.

```bash
xxd system.img
```

---

# Calcul des empreintes

SHA-256.

```bash
sha256sum fichier.img
```

SHA-1.

```bash
sha1sum fichier.img
```

MD5.

```bash
md5sum fichier.img
```

Le projet privilégie SHA-256.

---

# Sauvegarde

Copie bit à bit.

```bash
dd if=/dev/block/... of=partition.img
```

Progression.

```bash
dd if=... of=... status=progress
```

Synchronisation.

```bash
sync
```

---

# Compression

Créer une archive.

```bash
tar czf backup.tar.gz backups/
```

Extraction.

```bash
tar xzf backup.tar.gz
```

Compression rapide.

```bash
zstd
```

Décompression.

```bash
unzstd
```

---

# Inspection Android

Lister les partitions.

```bash
adb shell ls -l /dev/block/by-name
```

Lire une partition.

```bash
adb shell dd if=/dev/block/by-name/system of=/sdcard/system.img
```

Copie locale.

```bash
adb pull /sdcard/system.img
```

---

# Vérification avant reconstruction

Toujours contrôler :

```bash
e2fsck

↓

resize2fs

↓

sha256sum

↓

lpmake
```

Cette séquence réduit fortement les risques d'erreur.

---

# Outils utilisés

| Outil     | Fonction                             |
| --------- | ------------------------------------ |
| lsblk     | Liste des périphériques              |
| blkid     | UUID                                 |
| mount     | Montage                              |
| file      | Identification                       |
| simg2img  | Sparse → Raw                         |
| img2simg  | Raw → Sparse                         |
| e2fsck    | Vérification ext4                    |
| resize2fs | Redimensionnement                    |
| tune2fs   | Informations ext4                    |
| dumpe2fs  | Superbloc                            |
| lpunpack  | Extraction des partitions dynamiques |
| lpdump    | Métadonnées LP                       |
| lpmake    | Reconstruction                       |
| dd        | Sauvegarde bit à bit                 |
| sha256sum | Intégrité                            |

---

# Flux de travail recommandé

```text
Firmware OEM

↓

SHA-256

↓

Backup

↓

Extraction

↓

Conversion

↓

Montage

↓

Analyse

↓

Modification

↓

e2fsck

↓

resize2fs

↓

SHA-256

↓

lpmake

↓

Validation

↓

Flash
```

---

# Bonnes pratiques

- Toujours conserver une copie du firmware d'origine.
- Vérifier les empreintes SHA-256 avant et après chaque manipulation.
- Monter les images en lecture seule lorsque cela est possible.
- Exécuter `e2fsck` avant toute reconstruction.
- Documenter les tailles des partitions avant de les modifier.
- Ne jamais reconstruire `super.img` sans avoir validé individuellement chaque partition.
- Archiver les journaux et les commandes utilisées afin de garantir la reproductibilité des opérations.

---

# Commandes réellement utilisées dans HY300 Ultimate

Cette section est réservée aux commandes effectivement exécutées pendant le développement du projet.

Elle sera enrichie progressivement avec :

- les commandes d'extraction des partitions ;
- les scripts de reconstruction ;
- les paramètres `lpmake` validés ;
- les procédures de vérification ;
- les journaux de validation associés.

L'objectif est de distinguer les commandes de référence des commandes réellement employées dans HY300 Ultimate.