---
title: "Reconstruction de super.img avec lpmake"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 42 — Reconstruction de super.img avec lpmake

> *« Extraire une partition dynamique est relativement simple. La reconstruire correctement est l'une des opérations les plus complexes de tout l'écosystème Android moderne. »*

---

# Introduction

Après avoir étudié la structure interne de `super.img`, extrait les partitions logiques et réalisé les premières modifications du système, il devient nécessaire de reconstruire une nouvelle image `super.img`.

Cette étape constitue le cœur du projet **HY300 Ultimate**.

Contrairement aux anciennes générations d'Android, il ne suffit plus de copier plusieurs partitions les unes à côté des autres.

Depuis Android 10, l'image `super.img` contient :

- plusieurs partitions logiques ;
- des métadonnées LP ;
- une organisation en groupes ;
- des contraintes d'alignement ;
- des informations de redimensionnement destinées aux mises à jour OTA.

Reconstruire cette structure demande une compréhension précise du fonctionnement de `lpmake`.

---

# Pourquoi lpmake existe

Android utilise deux outils complémentaires.

```
lpunpack

↓

Extraction
```

```
lpmake

↓

Construction
```

Le premier démonte une image.

Le second la reconstruit.

Ils utilisent exactement le même format de métadonnées.

---

# Architecture de super.img

Une image moderne peut être représentée ainsi.

```
+-----------------------------------------+
| LP Metadata                             |
+-----------------------------------------+
| Groupe principal                        |
|                                         |
| system                                  |
| vendor                                  |
| product                                 |
| odm                                     |
| system_ext                              |
|                                         |
+-----------------------------------------+
```

Les partitions ne sont plus physiques.

Elles sont décrites dans les métadonnées LP.

---

# Le rôle des métadonnées

Les métadonnées décrivent notamment :

- le nombre de partitions ;
- leur ordre ;
- leur taille logique ;
- leur groupe ;
- leur alignement ;
- les slots éventuels (A/B).

Une erreur dans ces informations rend généralement l'image inutilisable.

---

# Les paramètres de lpmake

Une commande `lpmake` comprend plusieurs familles d'options.

Par exemple :

- taille totale de `super` ;
- nombre de slots ;
- taille des métadonnées ;
- groupes ;
- partitions ;
- images à intégrer.

Chaque paramètre doit correspondre au layout réel du firmware.

---

# Méthodologie retenue

Pour HY300 Ultimate, la reconstruction suit toujours les mêmes étapes.

1. Vérifier les images modifiées.
2. Contrôler leur taille.
3. Vérifier ext4 (`e2fsck`).
4. Calculer les nouveaux SHA-256.
5. Reconstruire `super.img`.
6. Vérifier l'image reconstruite.
7. Comparer avec l'original.
8. Préparer le flash.

Cette méthode limite les risques d'erreur.

---

# Vérification préalable

Avant toute reconstruction :

```bash
e2fsck -f system.img

e2fsck -f vendor.img

e2fsck -f product.img
```

Une image corrompue ne doit jamais être intégrée dans `super.img`.

---

# Contraintes de taille

Le principal piège rencontré avec `lpmake` concerne les tailles.

La somme des partitions logiques doit rester compatible avec :

- la taille du groupe ;
- la taille totale de `super` ;
- les contraintes d'alignement.

Un simple dépassement de quelques kilo-octets peut empêcher la reconstruction.

---

# Alignement

Les partitions sont alignées sur des frontières spécifiques.

L'alignement permet :

- de meilleures performances ;
- une compatibilité avec le stockage flash ;
- un fonctionnement correct des partitions dynamiques.

Il ne doit jamais être modifié arbitrairement.

---

# Les erreurs les plus fréquentes

Au cours de cette étude, plusieurs catégories d'erreurs ont été identifiées.

## Taille insuffisante

```
Not enough space
```

La partition reconstruite est plus grande que l'espace disponible.

---

## Métadonnées incohérentes

Les informations LP ne correspondent plus aux partitions.

---

## Groupe dépassé

Une partition dépasse la capacité du groupe auquel elle appartient.

---

## Mauvais ordre

Les partitions sont décrites dans un ordre incompatible avec le layout d'origine.

---

## Image ext4 invalide

Le système de fichiers est corrompu.

---

# Validation

Une fois reconstruite :

```
super-new.img
```

est soumise à plusieurs contrôles.

## Taille

Comparaison avec l'image d'origine.

---

## SHA-256

Nouvelle empreinte enregistrée.

---

## Extraction

Nouvelle extraction avec :

```bash
lpunpack
```

Si les partitions peuvent être réextraites correctement, cela constitue un premier indicateur de cohérence.

---

# Journal de développement

**Objectif**

Reconstruire une image `super.img` contenant les premières modifications du firmware.

**Résultat**

En cours de validation.

**Points de contrôle**

- cohérence des métadonnées ;
- compatibilité des tailles ;
- succès de l'extraction ;
- compatibilité avec le flash.

---

# Difficultés rencontrées

La reconstruction d'une partition dynamique est l'étape la plus sensible du projet.

Contrairement à une image `boot.img`, `super.img` rassemble plusieurs composants qui doivent rester cohérents entre eux.

Une erreur dans une seule partition peut compromettre l'ensemble de l'image.

---

# Ce que nous avons appris

Les partitions dynamiques offrent une grande souplesse aux constructeurs.

En contrepartie, elles rendent la personnalisation beaucoup plus complexe.

Le travail réalisé sur HY300 Ultimate montre qu'une reconstruction fiable repose avant tout sur :

- une bonne compréhension du layout ;
- des vérifications systématiques ;
- une documentation précise.

---

# Conclusion

La reconstruction de `super.img` constitue l'étape centrale de la création d'une ROM Android moderne.

Elle relie l'ensemble des opérations précédentes :

- extraction ;
- analyse ;
- modification ;
- validation.

Une fois cette étape maîtrisée, il devient possible de produire des firmwares personnalisés tout en conservant la structure attendue par Android.

---

> [!IMPORTANT]
> La commande `lpmake` n'est que la dernière étape du processus. Le succès de la reconstruction dépend principalement de la qualité des partitions préparées, de la cohérence des métadonnées et du respect du layout d'origine.