---
title: "Validation du plan de partition via Fastboot"
volume: 6
chapter: 62
status: complete
last_updated: 2026-07-15
authors:
  - Projet HY300 Ultimate
---

# Chapitre 62 — Validation du plan de partition via Fastboot

## Résumé

L'une des principales interrogations de ce projet concernait la fiabilité de la cartographie des partitions reconstruite lors des précédents volumes.

Cette cartographie avait été obtenue à partir de plusieurs sources :

- l'extraction complète du firmware ;
- l'analyse de `super.img` ;
- les partitions dynamiques ;
- les points de montage Android ;
- les liens symboliques présents dans `/dev/block/by-name`.

Bien que ces différentes sources soient cohérentes entre elles, elles proviennent toutes du système Android lui-même.

La découverte de Fastboot a permis de disposer d'une **source indépendante**, directement exposée par le firmware. Cette validation constitue une étape importante puisqu'elle confirme que la reconstruction du stockage réalisée jusqu'à présent correspond fidèlement à l'architecture réelle du projecteur.

---

# 62.1 Objectif

L'objectif de cette étape était de répondre aux questions suivantes :

- les partitions identifiées auparavant existent-elles réellement ?
- leurs tailles sont-elles correctes ?
- les partitions dynamiques sont-elles bien déclarées par le firmware ?
- la reconstruction de `super.img` repose-t-elle sur une architecture fidèle au matériel ?

Pour répondre à ces questions, aucune modification n'a été réalisée sur le périphérique.

Toutes les opérations ont été effectuées en lecture seule.

---

# 62.2 Méthodologie

La commande suivante a été exécutée :

```bash
fastboot getvar all
```

Contrairement à Android, Fastboot interroge directement les informations exposées par le firmware.

Les résultats obtenus sont donc indépendants :

- des points de montage ;
- des services Android ;
- du noyau en fonctionnement ;
- des fichiers système.

Ils constituent une référence particulièrement fiable.

---

# 62.3 Inventaire des partitions physiques

Fastboot retourne l'ensemble des partitions physiques présentes sur la mémoire eMMC.

| Partition     | Taille (Hex) | Taille approximative |
| ------------- | -----------: | -------------------: |
| metadata      | `0x01000000` |                16 Mo |
| super         | `0x96000000` |            ≈ 2,35 Go |
| cache         | `0x18000000` |               384 Mo |
| trust         | `0x00400000` |                 4 Mo |
| cust          | `0x04000000` |                64 Mo |
| recovery      | `0x06C00000` |               108 Mo |
| backup        | `0x17400000` |               372 Mo |
| security      | `0x00400000` |                 4 Mo |
| dtbo          | `0x00400000` |                 4 Mo |
| baseparameter | `0x00100000` |                 1 Mo |
| boot          | `0x02800000` |                40 Mo |
| uboot         | `0x00400000` |                 4 Mo |
| misc          | `0x00400000` |                 4 Mo |
| logo          | `0x04000000` |                64 Mo |
| vbmeta        | `0x00100000` |                 1 Mo |
| userdata      | `0xFDDF8000` |               ≈ 4 Go |

Cette liste correspond exactement aux partitions observées précédemment depuis Android et Recovery.

---

# 62.4 Validation des partitions dynamiques

Fastboot confirme explicitement que plusieurs partitions sont **logiques**.

Les variables suivantes sont retournées :

```text
is-logical:system:yes

is-logical:vendor:yes

is-logical:product:yes

is-logical:odm:yes

is-logical:system_ext:yes

is-logical:vendor_dlkm:yes

is-logical:odm_dlkm:yes
```

Cette information confirme que ces partitions ne sont pas présentes sous forme physique.

Elles résident toutes dans la partition :

```
super
```

L'organisation interne est donc la suivante :

```
super
│
├── system
├── system_ext
├── vendor
├── vendor_dlkm
├── product
├── odm
└── odm_dlkm
```

Cette architecture est conforme aux spécifications Android relatives aux **Dynamic Partitions**.

---

# 62.5 Taille des partitions logiques

Fastboot fournit également la taille réservée à chaque partition logique.

| Partition   | Taille (Hex) | Taille approximative |
| ----------- | -----------: | -------------------: |
| system      | `0x2F47F000` |             ≈ 756 Mo |
| system_ext  | `0x04729000` |              ≈ 71 Mo |
| vendor      | `0x1109D000` |             ≈ 273 Mo |
| vendor_dlkm | `0x01584000` |              ≈ 22 Mo |
| odm         | `0x332DE000` |             ≈ 819 Mo |
| odm_dlkm    | `0x00040000` |               256 Ko |
| product     | `0x0C7BD000` |             ≈ 200 Mo |

Ces valeurs sont cohérentes avec les images extraites lors de la reconstruction du firmware.

---

# 62.6 Validation de la reconstruction de super.img

Les premiers volumes avaient permis de reconstruire la structure de `super.img` grâce à :

- `lpunpack` ;
- les métadonnées LP ;
- l'analyse des images extraites.

Les informations obtenues via Fastboot confirment :

- l'existence de `super` ;
- la présence des partitions logiques ;
- leurs tailles respectives ;
- leur organisation générale.

Cette concordance renforce la confiance accordée au processus de reconstruction.

---

# 62.7 Absence de partitions A/B

Fastboot indique :

```text
slot-count:0
```

Les variables suivantes sont également présentes :

```text
has-slot:boot:no

has-slot:system:no

has-slot:vendor:no
```

Le HY300 Ultimate n'utilise donc pas les mises à jour transparentes (**Seamless Updates**) introduites sur certains appareils Android.

L'architecture repose sur un schéma classique à emplacement unique.

```
boot

↓

system

↓

userdata
```

Cette caractéristique simplifie la compréhension du firmware mais impose davantage de prudence lors du remplacement des partitions système.

---

# 62.8 Comparaison avec les analyses précédentes

Les informations obtenues au cours du projet peuvent désormais être comparées.

| Élément              | Android | Recovery | Fastboot |
| -------------------- | ------- | -------- | -------- |
| Table des partitions | ✔       | ✔        | ✔        |
| Partitions logiques  | ✔       | ✔        | ✔        |
| Dynamic Partitions   | ✔       | —        | ✔        |
| super.img            | ✔       | —        | ✔        |
| Tailles officielles  | —       | —        | ✔        |

Chaque environnement confirme les observations réalisées depuis les autres.

Cette convergence réduit considérablement le risque d'erreur.

---

# 62.9 Conséquences pour la ROM personnalisée

La validation de la table de partitions apporte plusieurs garanties.

## Reconstruction de super.img

La future ROM devra conserver exactement la même organisation interne.

Toute modification devra respecter :

- la taille maximale de `super` ;
- la taille de chaque partition logique ;
- les métadonnées LP.

---

## Respect de vbmeta

La présence d'une partition dédiée :

```
vbmeta
```

rappelle que le système utilise Android Verified Boot.

Les modifications futures devront tenir compte de cette chaîne de confiance.

---

## Préservation des partitions critiques

Certaines partitions ne doivent pas être modifiées sans justification :

- trust ;
- uboot ;
- dtbo ;
- vbmeta ;
- recovery.

Ces composants interviennent directement dans le démarrage du système.

---

# 62.10 Enseignements

Cette validation apporte une confirmation indépendante particulièrement importante.

Jusqu'à présent, la cartographie des partitions reposait principalement sur :

- l'extraction des images ;
- les analyses Android ;
- le reverse engineering.

Fastboot confirme désormais directement que cette cartographie correspond à l'architecture réellement implémentée par le constructeur.

La cohérence observée entre ces différentes sources renforce fortement la crédibilité des travaux réalisés.

---

# 62.11 Conclusion

L'analyse des informations exposées par Fastboot confirme que le HY300 Ultimate repose sur une architecture moderne utilisant :

- Android 12 ;
- Treble ;
- les partitions dynamiques ;
- `super.img` ;
- des partitions logiques ;
- Android Verified Boot.

Les tailles, la structure et l'organisation des partitions correspondent aux résultats obtenus lors des précédentes étapes du projet.

Cette validation indépendante constitue une étape essentielle avant toute reconstruction ou tout déploiement d'une ROM personnalisée, puisqu'elle garantit que les images générées pourront être comparées à une référence directement fournie par le firmware lui-même.