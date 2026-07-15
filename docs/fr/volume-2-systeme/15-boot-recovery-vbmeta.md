---
title: "Boot, Recovery et VBMeta"
author: "HY300 Ultimate Research"
version: "1.0"
language: "fr"
status: "Draft"
last_updated: "2026-07-14"
---

# Chapitre 15 — Boot, Recovery et VBMeta

> *« Un firmware Android n'est pas protégé par une seule partition. Il repose sur une chaîne de confiance où chaque étape vérifie la suivante. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre le rôle précis des partitions `boot`, `recovery` et `vbmeta` ;
- expliquer la différence entre Android normal et Recovery ;
- comprendre le fonctionnement de `applypatch` ;
- analyser le mécanisme de restauration automatique observé sur le HY300 ;
- distinguer les mécanismes AOSP des personnalisations constructeur.

---

# Introduction

Lorsqu'on parle de firmware Android, beaucoup pensent immédiatement à la partition `system`.

En réalité, Android ne pourrait jamais atteindre cette partition si trois composants essentiels n'étaient pas présents :

- `boot`
- `recovery`
- `vbmeta`

Ces trois partitions jouent un rôle fondamental.

Elles constituent le point de départ de toute la chaîne de démarrage.

Une corruption de l'une d'elles peut empêcher complètement le lancement du système.

Notre étude du HY300 a permis d'observer leur fonctionnement concret.

---

# Les trois piliers du démarrage

Le schéma simplifié est le suivant :

```text
Power ON

↓

BootROM

↓

U-Boot

↓

boot.img
        │
        ├──────── Android
        │
        └──────── Recovery

↓

vbmeta

↓

system
```

Avant qu'Android ne monte `system`, plusieurs vérifications peuvent déjà avoir eu lieu.

---

# La partition Boot

La partition `boot` constitue le véritable point d'entrée d'Android.

Elle contient généralement :

- le noyau Linux ;
- le ramdisk initial ;
- la ligne de commande du noyau ;
- diverses métadonnées.

Le noyau est chargé en mémoire par U-Boot.

Une fois exécuté, il initialise progressivement tout le système.

Sans `boot`, Android n'existe pas.

---

# Le ramdisk

Le ramdisk contenu dans `boot.img` est un système de fichiers minimal chargé en mémoire.

Il contient notamment :

- `init`
- les premiers scripts de démarrage
- certains fichiers de configuration

C'est depuis ce ramdisk que naît le processus `init`, identifié par le PID 1.

Toute la construction d'Android dépend ensuite de ce processus.

---

# La partition Recovery

Recovery constitue un second environnement de démarrage.

Contrairement à Android classique, il est conçu pour :

- installer des mises à jour OTA ;
- effacer certaines partitions ;
- réparer le système ;
- effectuer des opérations de maintenance.

Le Recovery est volontairement minimaliste.

Il n'exécute qu'une petite partie des services Android.

---

# Ce que nous avons observé

Notre première vérification consistait à rechercher tous les éléments liés au Recovery.

Commande utilisée :

```bash
find /system /vendor /odm \
  -type f \
  \( -name "*recovery*" -o -name "*.zip" -o -name "*ota*" \)
```

Les résultats ont immédiatement révélé plusieurs composants importants.

```text
/vendor/bin/install-recovery.sh

/vendor/etc/init/vendor_flash_recovery.rc

/vendor/recovery-from-boot.p

/system/etc/security/otacerts.zip

/system/bin/recovery-persist
```

Cette découverte montre que le constructeur n'utilise pas uniquement le Recovery standard d'AOSP.

Il ajoute également plusieurs mécanismes destinés à maintenir son intégrité.

---

# Analyse du script install-recovery.sh

Le fichier :

```text
/vendor/bin/install-recovery.sh
```

constitue probablement l'un des composants les plus intéressants du firmware.

Le cœur du script est le suivant :

```sh
applypatch --check recovery
```

Si cette vérification échoue :

```sh
applypatch \
  --patch recovery-from-boot.p \
  --source boot \
  --target recovery
```

Autrement dit :

Le système compare d'abord la partition Recovery avec l'image attendue.

Si une différence est détectée, il reconstruit automatiquement Recovery à partir de `boot` en appliquant un patch binaire.

Cette approche est typique des anciens mécanismes OTA d'Android.

---

# Pourquoi utiliser un patch ?

Reconstruire Recovery directement à partir d'une image complète serait coûteux.

Le constructeur préfère stocker uniquement :

```
boot

+

recovery-from-boot.p
```

Le patch contient uniquement les différences nécessaires.

Cette méthode réduit considérablement la taille du firmware.

---

# Le service associé

Le script précédent n'est jamais lancé directement.

Nous avons identifié le fichier suivant :

```text
/vendor/etc/init/vendor_flash_recovery.rc
```

Son contenu est particulièrement simple :

```text
service vendor_flash_recovery /vendor/bin/install-recovery.sh
    class main
    oneshot
```

Cette déclaration indique à `init` :

- d'exécuter le script ;
- une seule fois ;
- dans la classe principale des services.

Il s'agit donc d'un mécanisme entièrement intégré à la séquence de démarrage.

---

# Recovery Persist

Notre étude a également révélé :

```text
/system/bin/recovery-persist
```

Ce binaire est chargé de préserver certaines informations entre deux démarrages.

Selon les plateformes Android, il peut notamment :

- recopier des journaux ;
- conserver certains paramètres Recovery ;
- faciliter les diagnostics après une mise à jour.

Son comportement précis dépend du constructeur.

---

# Les certificats OTA

Nous avons ensuite extrait :

```text
/system/etc/security/otacerts.zip
```

Son contenu :

```text
testkey.x509.pem
```

L'analyse du certificat a montré :

- un certificat auto-signé ;
- une clé différente de la testkey publique AOSP ;
- une empreinte SHA-256 spécifique.

Nous avons volontairement comparé cette clé avec celle d'AOSP.

Résultat :

**elles sont différentes.**

Cela signifie que les mises à jour OTA attendues par cet appareil ne sont pas signées avec la clé de test publique d'Android.

---

# Ce que cela implique

Une mise à jour OTA doit être signée avec une clé reconnue par le système.

Dans notre cas :

- le certificat embarqué est spécifique au firmware étudié ;
- une OTA signée avec la testkey AOSP serait rejetée si la vérification est effectivement appliquée.

Nous n'avons toutefois pas cherché à contourner ce mécanisme.

Notre objectif était uniquement de le documenter.

---

# VBMeta

La partition `vbmeta` est utilisée par Android Verified Boot (AVB).

Son objectif est de garantir l'intégrité de plusieurs partitions critiques.

Selon la configuration du constructeur, elle peut vérifier notamment :

- `boot`
- `system`
- `vendor`
- d'autres partitions logiques

Cette vérification repose sur des empreintes cryptographiques.

Elle permet de détecter une modification non autorisée du firmware.

---

# Ce que nous savons

À ce stade de notre étude :

## Faits observés

- une partition `vbmeta` est présente ;
- `install-recovery.sh` est utilisé ;
- `applypatch` est appelé ;
- `recovery-from-boot.p` est présent ;
- `vendor_flash_recovery.rc` lance automatiquement le script ;
- `otacerts.zip` contient un certificat différent de la testkey publique AOSP.

## Ce que nous n'avons pas encore démontré

Nous n'avons pas encore établi expérimentalement :

- quelles partitions sont effectivement vérifiées par AVB ;
- si AVB est configuré en mode strict ou permissif ;
- quelles conséquences exactes aurait une modification de `vbmeta`.

Ces points feront l'objet d'un volume dédié à la sécurité.

---

# Implications pour le reverse engineering

Ces observations expliquent pourquoi toute modification du firmware doit être précédée d'une sauvegarde complète.

Modifier `system` est relativement simple.

Modifier `boot`, `recovery` ou `vbmeta` peut avoir des conséquences beaucoup plus importantes.

Avant toute expérimentation, nous avons donc systématiquement :

1. sauvegardé les partitions ;
2. calculé leur empreinte SHA-256 ;
3. conservé une copie intacte.

Cette discipline nous a permis de revenir à l'état d'origine à tout moment.

---

# Conclusion

L'étude de `boot`, `recovery` et `vbmeta` révèle que le HY300 suit largement les mécanismes de sécurité prévus par Android, tout en ajoutant des scripts spécifiques destinés à maintenir la cohérence de la partition Recovery.

Cette combinaison entre composants AOSP et personnalisations OEM illustre parfaitement la philosophie générale du firmware : réutiliser les briques standard d'Android tout en les adaptant aux besoins du constructeur.

Dans le chapitre suivant, nous analyserons un autre élément clé du démarrage : **`fstab.rk30board`**, le fichier qui décrit l'organisation complète des partitions et leurs options de montage.

---

> [!IMPORTANT]
> La présence d'un mécanisme de restauration automatique du Recovery ne signifie pas nécessairement qu'il est exécuté à chaque démarrage. Il indique en revanche que le constructeur a prévu un moyen de détecter et de corriger certaines altérations de cette partition.

---

## Chapitre suivant

➡️ **16 – `fstab.rk30board` : décryptage ligne par ligne**