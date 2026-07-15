---
title: "Conclusions du Volume II"
author: "HY300 Ultimate Research"
version: "1.0"
language: "fr"
status: "Draft"
last_updated: "2026-07-14"
---

# Chapitre 19 — Conclusions du Volume II

> *« Comprendre un système est toujours plus puissant que savoir le modifier. »*

---

# Introduction

Au début de cette étude, le HY300 n'était qu'un simple vidéoprojecteur Android.

Son fonctionnement interne était largement inconnu.

Le constructeur ne publie pratiquement aucune documentation technique.

La plupart des informations disponibles sur Internet sont fragmentaires, incomplètes ou concernent d'autres appareils.

Notre objectif n'était pas uniquement de produire un firmware modifié.

Nous voulions comprendre précisément le fonctionnement de la plateforme.

Cette différence de philosophie a profondément influencé toute la méthodologie adoptée dans ce projet.

---

# Ce que nous avons appris

Au fil des chapitres, nous avons progressivement reconstruit l'architecture complète du système.

Nous savons désormais :

- comment le RK3326 démarre ;
- comment Android est construit progressivement ;
- comment les partitions sont organisées ;
- comment fonctionne `super.img` ;
- où résident les composants OEM ;
- comment Android monte ses partitions ;
- comment la mémoire est gérée ;
- comment les services système sont lancés.

Ces connaissances constituent désormais une base solide pour poursuivre le reverse engineering du firmware.

---

# Une architecture beaucoup plus moderne qu'attendu

L'une des surprises de cette étude est le niveau de conformité du HY300 avec les recommandations de Google.

Malgré son positionnement comme appareil multimédia d'entrée de gamme, le projecteur adopte plusieurs technologies récentes :

- Android 12 ;
- Project Treble ;
- partitions dynamiques ;
- `super.img` ;
- `vbmeta` ;
- `metadata` ;
- `system_ext` ;
- `vendor_dlkm` ;
- `odm_dlkm` ;
- `first_stage_mount`.

Autrement dit, le constructeur n'a pas développé un système propriétaire.

Il s'appuie largement sur les fondations offertes par Android moderne.

Cette constatation simplifie considérablement l'analyse du firmware.

---

# Les spécificités du constructeur

Le système n'est toutefois pas un Android AOSP pur.

Notre enquête a mis en évidence plusieurs personnalisations :

- services OTA ;
- scripts de restauration du Recovery ;
- mécanismes `applypatch` ;
- applications spécifiques au projecteur ;
- composants Keystone ;
- bibliothèques natives dédiées ;
- configurations Rockchip.

Ces éléments sont précisément ceux qui différencient le HY300 d'une tablette Android classique.

Ils constitueront le cœur du prochain volume.

---

# Une méthodologie fondée sur les preuves

Tout au long de cette étude, nous avons appliqué une règle simple :

> **Ne jamais supposer lorsqu'une observation est possible.**

Chaque affirmation importante repose sur :

- une commande réellement exécutée ;
- un fichier réellement extrait ;
- une partition réellement analysée ;
- une empreinte cryptographique réellement calculée.

Lorsque nous formulons une hypothèse, celle-ci est explicitement identifiée comme telle.

Cette distinction entre faits et interprétations est essentielle pour produire une documentation fiable et reproductible.

---

# Les outils mobilisés

L'analyse du HY300 s'est appuyée sur des outils issus de différents domaines :

## Outils Android

- `adb`
- `fastboot`
- `applypatch`
- `getprop`
- `logcat`

## Outils Linux

- `dd`
- `mount`
- `df`
- `sha256sum`
- `find`
- `stat`
- `grep`

## Outils cryptographiques

- `openssl`
- `sha256`

## Outils de manipulation des partitions dynamiques

- `lpunpack`
- `lpmake`

## Outils de rétro-ingénierie

- extraction des APK ;
- analyse des scripts shell ;
- inspection des fichiers `.rc` ;
- comparaison d'images système.

Cette diversité illustre la nature pluridisciplinaire du reverse engineering Android.

---

# Ce que nous avons volontairement évité

Certaines pratiques courantes dans la communauté Android n'ont pas été retenues.

Par exemple :

- modifier directement des partitions sans sauvegarde préalable ;
- désactiver les mécanismes de sécurité sans en comprendre le fonctionnement ;
- remplacer des composants système sans vérifier leur intégrité ;
- publier des hypothèses comme des faits.

Notre objectif n'était pas de produire un simple tutoriel de modification.

Nous voulions construire une documentation scientifique, durable et exploitable.

---

# Les limites de cette étude

Malgré l'ampleur du travail réalisé, plusieurs points restent ouverts.

Nous n'avons pas encore étudié en profondeur :

- les bibliothèques natives du constructeur ;
- les applications OEM ;
- les mécanismes OTA complets ;
- les services Keystone ;
- les optimisations graphiques ;
- les performances réelles du pipeline vidéo ;
- les interactions entre Android et certains composants Rockchip.

Ces sujets feront l'objet des volumes suivants.

---

# Ce que cette étude apporte à la communauté

Le HY300 appartient à une famille d'appareils largement diffusés sous différentes marques.

Beaucoup partagent :

- le même SoC ;
- le même firmware de base ;
- les mêmes composants logiciels.

En documentant précisément cette plateforme, ce projet dépasse largement le cadre d'un seul modèle.

Les méthodes décrites ici pourront être adaptées à d'autres appareils Android embarqués reposant sur Rockchip ou sur des architectures proches.

---

# Une philosophie : comprendre avant de modifier

Une grande partie des ressources disponibles en ligne explique **comment** modifier un firmware.

Très peu expliquent **pourquoi** ces manipulations fonctionnent.

Nous avons volontairement adopté la démarche inverse.

Chaque opération réalisée au cours de cette étude est replacée dans son contexte architectural.

Cette approche demande davantage de temps.

En contrepartie, elle permet de produire un savoir réutilisable bien au-delà du HY300.

---

# Préparer le Volume III

Le lecteur dispose maintenant de toutes les connaissances nécessaires pour aborder les composants propriétaires du firmware.

Le prochain volume sera consacré à leur analyse détaillée.

Nous y étudierons notamment :

- les APK système ;
- les bibliothèques natives (`.so`) ;
- les scripts OEM ;
- les services propriétaires ;
- les mécanismes OTA ;
- les composants Keystone ;
- les optimisations apportées par le constructeur.

À ce stade, nous ne chercherons plus à comprendre **Android**.

Nous chercherons à comprendre **ce que le constructeur a ajouté à Android**.

---

# Conclusion générale

Le Volume II marque une étape essentielle du projet HY300 Ultimate.

Nous sommes passés d'une simple connaissance fonctionnelle du projecteur à une compréhension détaillée de son architecture logicielle.

Cette progression repose sur une méthodologie rigoureuse :

- observer ;
- extraire ;
- vérifier ;
- documenter ;
- seulement ensuite interpréter.

Cette discipline a permis de constituer une base de connaissances fiable, reproductible et directement exploitable pour les travaux futurs.

---

# En résumé

À l'issue de ce volume, nous savons :

✓ comment le SoC RK3326 initialise le système ;

✓ comment Android est chargé en mémoire ;

✓ comment `init` construit progressivement l'environnement d'exécution ;

✓ comment les partitions sont organisées ;

✓ comment fonctionne `super.img` ;

✓ comment Android monte ses systèmes de fichiers ;

✓ comment la mémoire est optimisée grâce à ZRAM ;

✓ où résident les composants du constructeur ;

✓ quelles sont les bases nécessaires pour poursuivre le reverse engineering.

Ces acquis constituent désormais les fondations du projet HY300 Ultimate.

---

> [!SUCCESS]
>
> Le Volume II ne cherche pas uniquement à expliquer le fonctionnement du HY300. Il propose une méthode d'analyse applicable à de nombreux appareils Android embarqués. En privilégiant les observations reproductibles, la documentation détaillée et la séparation explicite entre faits et hypothèses, ce projet vise à constituer une ressource technique ouverte, durable et utile à l'ensemble de la communauté.

---

# Prochain volume

➡️ **Volume III — Reverse Engineering des composants OEM**

Au programme :

- Inventaire complet des APK système.
- Analyse des bibliothèques natives.
- Étude des scripts du constructeur.
- Reverse engineering des services OTA.
- Analyse du moteur Keystone.
- Documentation des applications propriétaires.
- Identification des bloatwares et des composants non documentés.