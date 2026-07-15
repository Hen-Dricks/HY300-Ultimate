---
title: "ZRAM, mémoire compressée et gestion de la RAM"
author: "HY300 Ultimate Research"
version: "1.0"
language: "fr"
status: "Draft"
last_updated: "2026-07-14"
---

# Chapitre 17 — ZRAM, mémoire compressée et gestion de la RAM

> *« La meilleure optimisation mémoire n'est pas forcément d'ajouter de la RAM. C'est souvent d'utiliser intelligemment celle qui existe déjà. »*

---

# Objectifs

À la fin de ce chapitre, le lecteur comprendra :

- pourquoi Android utilise ZRAM ;
- la différence entre ZRAM, Swap et RAM classique ;
- comment le HY300 gère sa mémoire ;
- pourquoi le constructeur a choisi une ZRAM représentant 75 % de la RAM physique ;
- les conséquences sur les performances.

---

# Introduction

Le HY300 ne possède pas une quantité importante de mémoire vive.

Sur un appareil de ce type, plusieurs processus doivent pourtant cohabiter :

- Android ;
- SurfaceFlinger ;
- le Launcher ;
- les services OEM ;
- les applications de streaming ;
- les processus système ;
- le décodage vidéo.

Sans mécanisme particulier, la mémoire serait rapidement saturée.

Google utilise donc une technologie appelée **ZRAM**.

Notre analyse du fichier `fstab.rk30board` confirme que le constructeur l'a activée.

---

# Ce que nous avons observé

Dans le fichier :

```text
/vendor/etc/fstab.rk30board
```

nous avons identifié la ligne suivante :

```fstab
/dev/block/zram0 none swap defaults \
zramsize=75%,max_comp_streams=8,zram_backingdev_size=256M
```

Cette simple ligne décrit toute la stratégie mémoire du constructeur.

---

# Qu'est-ce que ZRAM ?

Contrairement à une idée reçue, ZRAM n'ajoute pas de mémoire.

Elle crée un périphérique bloc virtuel directement en RAM.

Ce périphérique sert de zone d'échange (*swap*), mais les données qui y sont stockées sont compressées.

Le schéma est le suivant :

```text
RAM physique
        │
        ├──────── Mémoire normale
        │
        └──────── ZRAM
                    │
                    └──────── Pages compressées
```

Le système peut ainsi conserver davantage de données en mémoire sans accéder au stockage eMMC.

---

# Pourquoi ne pas utiliser la mémoire eMMC ?

Sous Linux classique, le swap est souvent placé sur un disque.

Sur Android, cette approche est moins adaptée.

Les raisons sont multiples :

- une eMMC est beaucoup plus lente que la RAM ;
- les écritures répétées accélèrent son usure ;
- les performances deviennent médiocres lors des accès intensifs.

En utilisant une zone compressée directement en mémoire, Android évite ces inconvénients.

---

# Décryptage de la configuration

Analysons maintenant chaque paramètre observé.

## `/dev/block/zram0`

Il s'agit du périphérique ZRAM créé par le noyau Linux.

Bien qu'il apparaisse comme un périphérique bloc, il ne correspond pas à un disque physique.

Toutes les données restent stockées en mémoire vive.

---

## `swap`

Cette option indique que ZRAM sera utilisée comme espace d'échange.

Lorsque certaines pages mémoire deviennent peu utilisées, Android peut les déplacer dans cette zone compressée.

Cela libère de la RAM pour les applications actives.

---

## `zramsize=75%`

C'est probablement le paramètre le plus intéressant.

Le constructeur réserve une taille maximale correspondant à **75 % de la mémoire vive**.

Prenons un exemple.

Si l'appareil dispose de :

```text
2 Go de RAM
```

Android pourra créer une ZRAM pouvant atteindre environ :

```text
1,5 Go
```

Cette valeur est une limite supérieure.

Elle ne signifie pas que cette quantité sera immédiatement consommée.

---

## Pourquoi 75 % ?

Il n'existe pas de valeur universelle.

Google recommande d'adapter cette taille au profil matériel de l'appareil.

Pour un vidéoprojecteur :

- peu de multitâche ;
- quelques applications lourdes (YouTube, Netflix, Kodi) ;
- peu de changements rapides d'applications.

Un ratio élevé permet de conserver davantage de processus en mémoire sans recharger constamment les applications.

Il s'agit donc d'un compromis entre réactivité et consommation CPU.

---

## `max_comp_streams=8`

Ce paramètre définit le nombre maximal de flux de compression parallèles.

En pratique, cela permet à plusieurs cœurs CPU de travailler simultanément sur la compression et la décompression des pages mémoire.

Sur un SoC multicœur comme le RK3326, ce choix est cohérent.

Il améliore les performances lorsque plusieurs opérations mémoire se produisent en parallèle.

---

## `zram_backingdev_size=256M`

Ce paramètre réserve un espace de **256 Mo** pour le périphérique de support (*backing device*).

Selon la configuration du noyau, cette réserve peut être utilisée pour certaines optimisations internes de ZRAM.

Nous avons identifié sa présence, mais nous n'avons pas confirmé expérimentalement la manière exacte dont elle est exploitée sur ce firmware.

Il convient donc de rester prudent quant à son interprétation.

---

# Comment Android décide-t-il d'utiliser ZRAM ?

Android ne déplace pas immédiatement les données dans ZRAM.

Plusieurs composants interviennent :

- le noyau Linux ;
- le gestionnaire mémoire ;
- LMKD (*Low Memory Killer Daemon*).

Lorsque la pression mémoire augmente, certaines pages peu utilisées sont compressées et déplacées dans ZRAM.

Si cela ne suffit plus, LMKD peut décider de terminer certains processus pour libérer davantage de mémoire.

---

# Ce que cela signifie pour le HY300

Le choix d'une ZRAM de grande taille indique que le constructeur cherche à privilégier la fluidité de l'interface plutôt qu'une fermeture agressive des applications.

Cette stratégie est logique pour un appareil destiné au multimédia.

Elle permet notamment :

- de conserver le Launcher en mémoire ;
- de limiter les rechargements d'applications ;
- de réduire les accès au stockage interne.

---

# Optimisations possibles

L'analyse de cette configuration ouvre plusieurs pistes d'expérimentation.

Par exemple :

- mesurer l'occupation réelle de ZRAM en usage courant ;
- comparer différents algorithmes de compression (si le noyau les prend en charge) ;
- évaluer l'impact d'une taille de ZRAM différente.

Ces expérimentations n'ont pas été réalisées dans le cadre de cette étude et sont proposées comme travaux futurs.

---

# Ce que nous avons réellement observé

### Faits

- ZRAM est activée.
- Le périphérique est `zram0`.
- La taille maximale est fixée à 75 % de la RAM.
- Huit flux de compression sont autorisés.
- Un paramètre `zram_backingdev_size=256M` est présent.

### Ce que cela signifie

Le constructeur a configuré le système pour privilégier une utilisation intensive de la mémoire compressée, ce qui est cohérent avec les contraintes d'un appareil multimédia disposant de ressources matérielles limitées.

---

# Conclusion

La mémoire du HY300 n'est pas gérée uniquement par la quantité de RAM disponible.

Elle repose sur une stratégie combinant :

- mémoire physique ;
- mémoire compressée (ZRAM) ;
- politique du noyau Linux ;
- décisions de LMKD.

Comprendre cette architecture est indispensable avant d'envisager toute optimisation des performances.

---

> [!IMPORTANT]
> Augmenter arbitrairement la taille de ZRAM n'améliore pas nécessairement les performances. Une zone de compression plus grande peut également augmenter la charge CPU. Toute modification doit être validée par des mesures objectives.

---

# Chapitre suivant

➡️ **18 – Les services `init` et la naissance du système Android**