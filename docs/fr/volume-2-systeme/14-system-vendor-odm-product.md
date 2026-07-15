---
title: "System, Vendor, ODM et Product"
author: "HY300 Ultimate Research"
version: "1.0"
language: "fr"
status: "Draft"
last_updated: "2026-07-14"
---

# Chapitre 14 — System, Vendor, ODM et Product

> *« Une ROM Android moderne n'est plus un bloc unique. C'est un ensemble de couches indépendantes qui coopèrent pour faire fonctionner l'appareil. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur sera capable de :

- comprendre pourquoi Google a créé Project Treble ;
- distinguer clairement `system`, `vendor`, `odm`, `product` et `system_ext` ;
- savoir où chercher une application ou une bibliothèque système ;
- comprendre où les fabricants ajoutent leurs personnalisations ;
- appliquer ces connaissances au firmware du HY300.

---

# Introduction

Jusqu'à Android 7, le système d'exploitation était relativement simple.

La majorité des fichiers se trouvait dans une seule partition :

```
system
```

Le framework Android, les applications système, les bibliothèques natives et même certains composants spécifiques au constructeur cohabitaient au même endroit.

Cette approche fonctionnait.

Mais elle posait un problème majeur.

Chaque mise à jour Android imposait aux constructeurs de réadapter une grande partie de leurs modifications.

Les délais étaient longs.

Les mises à jour rares.

Pour résoudre ce problème, Google introduisit progressivement **Project Treble**, généralisé à partir d'Android 8.

Treble repose sur une idée simple :

**séparer clairement ce qui appartient à Google de ce qui appartient au constructeur.**

---

# Vue d'ensemble

Sur le HY300, nous avons identifié les partitions logiques suivantes :

```text
super

├── system
├── system_ext
├── vendor
├── vendor_dlkm
├── odm
├── odm_dlkm
└── product
```

Chaque partition possède un rôle spécifique.

---

# La partition `system`

`system` constitue le cœur d'Android.

Elle contient principalement les composants issus d'AOSP.

On y retrouve notamment :

```text
/system/bin
/system/lib
/system/lib64
/system/framework
/system/app
/system/priv-app
```

Ces répertoires regroupent :

- les binaires Android ;
- les bibliothèques standard ;
- le framework Java ;
- les applications système de base.

En règle générale, Google est le principal auteur du contenu de cette partition.

---

## Que trouve-t-on dans `/system/app` ?

Cette arborescence contient les applications système qui ne nécessitent pas de privilèges particuliers.

Exemples typiques :

- Calculatrice
- Horloge
- Gestionnaire de fichiers
- Visionneuse de documents

Sur le HY300, nous avons également identifié des applications spécifiques, notamment :

```text
/system/app/txcz_ota/
```

Cette application est chargée de la gestion des mises à jour OTA du constructeur.

Sa présence dans `system` indique qu'elle est considérée comme un composant essentiel du firmware.

---

# La partition `vendor`

La partition `vendor` est destinée aux composants dépendants du matériel.

Elle contient notamment :

```text
/ vendor/bin
/ vendor/lib
/ vendor/etc
/ vendor/firmware
```

Dans notre étude, cette partition s'est révélée particulièrement intéressante.

Nous y avons identifié plusieurs fichiers essentiels au fonctionnement du projecteur.

Par exemple :

```text
/vendor/bin/install-recovery.sh
```

ou encore :

```text
/vendor/etc/init/vendor_flash_recovery.rc
```

Ces éléments montrent que le constructeur a choisi d'implémenter certains mécanismes de maintenance directement dans `vendor`, ce qui est cohérent avec la philosophie de Project Treble.

---

## Pourquoi `vendor` est-elle importante ?

Le framework Android ne dialogue jamais directement avec les pilotes matériels.

Il passe par des interfaces standardisées (HAL).

Ces interfaces et leurs bibliothèques résident principalement dans `vendor`.

Modifier cette partition peut donc avoir un impact direct sur :

- le Wi-Fi ;
- le Bluetooth ;
- l'affichage ;
- l'audio ;
- la vidéo ;
- les composants spécifiques au projecteur.

---

# La partition `odm`

`ODM` signifie **Original Design Manufacturer**.

Elle est destinée aux personnalisations propres à un modèle particulier.

Sur certains appareils, elle est presque vide.

Sur d'autres, elle contient :

- des fichiers de configuration ;
- des ressources graphiques ;
- des pilotes complémentaires ;
- des services spécifiques.

Le HY300 possède bien une partition `odm`, ce qui confirme que le constructeur utilise pleinement l'architecture Treble.

Son contenu détaillé sera analysé dans un volume consacré au reverse engineering des composants OEM.

---

# La partition `product`

`product` est généralement utilisée pour les éléments directement visibles par l'utilisateur.

On y trouve souvent :

```text
/product/app
/product/overlay
/product/media
/product/etc
```

Cette séparation permet au constructeur de personnaliser l'expérience utilisateur sans modifier directement le framework Android.

Selon les appareils, cette partition peut contenir :

- des applications constructeur ;
- des thèmes ;
- des fonds d'écran ;
- des polices ;
- des overlays de ressources.

---

# La partition `system_ext`

Introduite avec Android récent, `system_ext` permet d'étendre le framework sans modifier `system`.

Elle accueille des composants qui restent proches d'AOSP mais qui ne font pas partie du noyau officiel du système.

Cette approche facilite les mises à jour tout en laissant davantage de liberté aux constructeurs.

---

# Les partitions `vendor_dlkm` et `odm_dlkm`

Le suffixe `dlkm` signifie **Dynamic Loadable Kernel Modules**.

Ces partitions contiennent les modules du noyau Linux chargés dynamiquement.

Leur apparition répond à un besoin simple :

mettre à jour certains pilotes sans reconstruire l'ensemble du noyau.

Cette modularité est particulièrement utile pour les constructeurs qui souhaitent faire évoluer rapidement une partie de leur pile matérielle.

---

# Ce que nous avons observé sur le HY300

Notre analyse du firmware a permis d'identifier plusieurs composants intéressants.

### OTA

```
/system/app/txcz_ota/
```

Gestion des mises à jour constructeur.

---

### Script de restauration Recovery

```
/vendor/bin/install-recovery.sh
```

Ce script compare le contenu de la partition `recovery` et, si nécessaire, la reconstruit à partir de `boot` en utilisant `applypatch`.

---

### Configuration du service

```
/vendor/etc/init/vendor_flash_recovery.rc
```

Ce fichier déclare un service `vendor_flash_recovery` exécuté une seule fois (`oneshot`) au démarrage.

Nous l'avons analysé en détail lors de notre enquête.

---

### Certificats OTA

```
/system/etc/security/otacerts.zip
```

Nous avons extrait cette archive et identifié un certificat de signature spécifique au constructeur.

Son empreinte SHA-256 diffère de celle du certificat de test AOSP, ce qui indique que le firmware utilise une clé distincte pour vérifier les mises à jour.

Cette découverte sera approfondie dans le volume consacré à la sécurité.

---

# Pourquoi cette séparation est importante

Lorsqu'un développeur souhaite modifier un firmware, il est essentiel de savoir où intervenir.

Quelques exemples :

- Modifier une application système ? → `system` ou `product`.
- Ajouter un pilote ? → `vendor`.
- Modifier un module noyau ? → `vendor_dlkm`.
- Adapter un composant spécifique au matériel ? → `odm`.

Cette compréhension évite de modifier inutilement des partitions qui ne sont pas concernées.

---

# Ce que cette architecture apporte

Grâce à Project Treble :

- Google peut mettre à jour le framework Android indépendamment des pilotes ;
- le constructeur peut faire évoluer ses composants matériels sans reconstruire tout le système ;
- certaines mises à jour deviennent plus simples à distribuer.

En contrepartie, le firmware est plus fragmenté et demande une meilleure compréhension de ses différentes couches.

---

# Ce que nous avons appris

Notre étude montre que le HY300 respecte globalement l'organisation moderne d'Android.

Le constructeur concentre ses personnalisations dans `vendor`, `odm` et `product`, tout en conservant un framework relativement proche d'AOSP.

Cette architecture facilite notre travail de reverse engineering : elle nous permet de cibler précisément les composants OEM sans perturber les fondations du système.

---

> [!IMPORTANT]
> Avant de modifier un composant, identifiez toujours la partition à laquelle il appartient. Une modification dans `system` n'aura pas les mêmes conséquences qu'une modification dans `vendor` ou `boot`.

---

# Conclusion

La séparation introduite par Project Treble est l'une des évolutions les plus importantes de l'histoire d'Android.

Comprendre cette organisation est indispensable pour analyser un firmware moderne.

Dans le chapitre suivant, nous nous intéresserons à trois partitions particulièrement sensibles : **`boot`**, **`recovery`** et **`vbmeta`**. Nous expliquerons leur rôle dans la chaîne de démarrage, Android Verified Boot (AVB) et les mécanismes de restauration que nous avons effectivement observés sur le HY300.

---

## Chapitre suivant

➡️ **15 – Boot, Recovery et VBMeta : les fondations du démarrage sécurisé**