---
title: "Annexe E — Erreurs et solutions"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "fr"
last_updated: "2026-07-14"
---

# Annexe E — Erreurs et solutions

> *« Une erreur correctement documentée devient une connaissance. Une erreur oubliée est condamnée à se reproduire. »*

---

# Objectif

Cette annexe rassemble les principaux problèmes susceptibles d'être rencontrés lors :

- de l'extraction du firmware ;
- de la modification des partitions ;
- de la reconstruction ;
- du flash ;
- des phases de validation.

Les solutions proposées reposent sur des méthodes reproductibles et doivent toujours être adaptées au contexte de chaque expérimentation.

---

# Structure d'une fiche de dépannage

Chaque problème est présenté selon le même modèle.

```
Symptôme

↓

Causes probables

↓

Diagnostic

↓

Résolution

↓

Prévention
```

Cette structure facilite le diagnostic tout en permettant d'éviter la réapparition du problème.

---

# 1. ADB ne détecte pas l'appareil

## Symptôme

```text
List of devices attached

<aucun appareil>
```

## Causes probables

- câble USB défectueux ;
- autorisation ADB non acceptée ;
- débogage USB désactivé ;
- serveur ADB bloqué.

## Diagnostic

```bash
adb devices

adb kill-server

adb start-server
```

## Résolution

```bash
adb kill-server
adb start-server
adb devices
```

Reconnecter ensuite le câble USB et accepter la demande d'autorisation sur l'appareil si elle apparaît.

## Prévention

Toujours vérifier la connexion ADB avant de lancer une opération importante.

---

# 2. Impossible de monter une image ext4

## Symptôme

```text
mount: wrong filesystem type
```

## Causes probables

- image au format Sparse ;
- image corrompue ;
- système de fichiers incohérent.

## Diagnostic

```bash
file system.img
```

```bash
e2fsck -f system.img
```

## Résolution

Si l'image est au format Sparse :

```bash
simg2img system.img system.raw.img
```

Puis monter `system.raw.img`.

## Prévention

Toujours identifier le type d'image avant le montage.

---

# 3. e2fsck détecte des erreurs

## Symptôme

```text
Filesystem errors found
```

## Diagnostic

```bash
e2fsck -f system.raw.img
```

## Résolution

```bash
e2fsck -fy system.raw.img
```

Relancer ensuite une vérification.

## Prévention

Toujours démonter correctement les images avant leur reconstruction.

---

# 4. lpunpack échoue

## Symptôme

```text
Unable to parse metadata
```

## Causes probables

- image incomplète ;
- fichier corrompu ;
- format non valide.

## Diagnostic

```bash
sha256sum super.img

file super.img
```

## Résolution

Comparer l'image avec la sauvegarde d'origine et vérifier son intégrité.

## Prévention

Toujours calculer une empreinte SHA-256 après extraction.

---

# 5. lpmake échoue

## Symptôme

```text
Partition does not fit
```

## Causes probables

- partition trop volumineuse ;
- mauvais dimensionnement ;
- groupe LP dépassé.

## Diagnostic

Vérifier :

- la taille des partitions ;
- les groupes LP ;
- les paramètres transmis à `lpmake`.

## Résolution

Réduire la taille de la partition.

```bash
resize2fs
```

Puis reconstruire.

## Prévention

Contrôler les tailles avant toute reconstruction.

---

# 6. Bootloop après le flash

## Symptôme

L'appareil redémarre en boucle.

## Causes probables

- partition incorrecte ;
- composant système supprimé ;
- erreur dans la reconstruction.

## Diagnostic

Collecter les journaux si possible.

```bash
adb logcat

adb shell dmesg
```

## Résolution

Restaurer une sauvegarde connue comme fonctionnelle.

## Prévention

N'effectuer qu'une seule modification entre deux validations.

---

# 7. Docker ne démarre pas

## Symptôme

```text
Cannot connect to the Docker daemon
```

## Diagnostic

```bash
docker info
```

## Résolution

Démarrer Docker Desktop ou le service Docker selon le système utilisé.

## Prévention

Vérifier que Docker est opérationnel avant toute reconstruction.

---

# 8. Conflits Git

## Symptôme

```text
Merge conflict
```

## Diagnostic

```bash
git status
```

## Résolution

Identifier les fichiers concernés, résoudre les conflits puis valider les modifications.

## Prévention

Créer des commits fréquents et limiter chaque commit à une modification logique.

---

# 9. Erreur de permissions

## Symptôme

```text
Permission denied
```

## Diagnostic

```bash
ls -l
```

## Résolution

```bash
chmod +x script.sh
```

ou

```bash
sudo chown
```

selon le contexte.

## Prévention

Conserver des permissions cohérentes dans le dépôt Git.

---

# 10. Empreinte SHA-256 différente

## Symptôme

```text
FAILED
```

lors de :

```bash
sha256sum -c SHA256SUMS
```

## Causes probables

- fichier modifié ;
- transfert incomplet ;
- corruption.

## Diagnostic

Comparer :

- la taille ;
- la date ;
- l'origine du fichier.

## Résolution

Remplacer le fichier par une copie valide.

## Prévention

Vérifier systématiquement les empreintes après chaque transfert.

---

# Tableau de diagnostic rapide

| Symptôme                  | Vérification recommandée |
| ------------------------- | ------------------------ |
| ADB absent                | `adb devices`            |
| Image illisible           | `file`                   |
| Erreur ext4               | `e2fsck`                 |
| Taille incorrecte         | `resize2fs`              |
| Reconstruction impossible | `lpmake`                 |
| Bootloop                  | `logcat` / `dmesg`       |
| Docker indisponible       | `docker info`            |
| Conflit Git               | `git status`             |
| Permission refusée        | `ls -l`                  |
| Hash invalide             | `sha256sum -c`           |

---

# Procédure générale de dépannage

```
Identifier le symptôme

↓

Conserver les journaux

↓

Calculer les empreintes

↓

Vérifier les tailles

↓

Tester une hypothèse

↓

Appliquer une seule correction

↓

Valider

↓

Documenter
```

Cette méthode évite les modifications multiples qui compliquent le diagnostic.

---

# Journal des incidents

Chaque incident rencontré pendant le développement devrait être documenté.

| Date        | Problème | Cause | Solution | Résolu |
| ----------- | -------- | ----- | -------- | :----: |
| À compléter |          |       |          |        |

Ce journal permettra de conserver un historique des difficultés rencontrées et des solutions retenues.

---

# Bonnes pratiques

- Toujours conserver les journaux d'erreur.
- Ne modifier qu'un seul paramètre à la fois.
- Vérifier les sauvegardes avant toute restauration.
- Documenter les commandes réellement exécutées.
- Mettre à jour cette annexe lorsqu'un nouveau problème est identifié.

---

> [!TIP]
> Lorsqu'un problème survient, résistez à la tentation de modifier plusieurs éléments simultanément. Une démarche progressive, où chaque changement est isolé puis validé, réduit considérablement le temps nécessaire pour identifier la cause réelle de l'erreur.