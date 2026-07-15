---
title: "Ce qu'il ne faut pas faire"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Completed"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 54 — Ce qu'il ne faut pas faire

> *« La majorité des échecs rencontrés pendant le développement d'un firmware ne proviennent pas d'un manque de compétences, mais d'une succession de petites erreurs évitables. »*

---

# Résumé exécutif

Le développement d'un firmware Android moderne est une activité où chaque modification peut avoir des conséquences importantes.

Au cours du projet HY300 Ultimate, plusieurs principes se sont imposés.

Ils ne constituent pas uniquement de bonnes pratiques.

Ils représentent les règles qui ont permis d'éviter la corruption des partitions, les pertes de données et les heures de débogage inutiles.

Ce chapitre rassemble les erreurs les plus fréquentes observées dans les projets communautaires ainsi que les méthodes utilisées pour les éviter.

---

# 1. Ne jamais modifier l'image originale

L'erreur la plus grave consiste à travailler directement sur :

```
system.img

vendor.img

super.img
```

issus du firmware constructeur.

Toujours créer une copie.

```
Firmware OEM

↓

Backup

↓

Working Copy

↓

Modifications
```

Ainsi, un retour arrière reste toujours possible.

---

# 2. Ne jamais effectuer plusieurs modifications simultanément

Très souvent :

```
Suppression APK

+

Modification build.prop

+

Remplacement Launcher

+

Modification init.rc
```

Puis :

```
Bootloop
```

Impossible ensuite d'identifier l'origine du problème.

La règle utilisée pendant tout le projet est simple.

```
Une modification

↓

Reconstruction

↓

Test

↓

Validation

↓

Modification suivante
```

---

# 3. Ne jamais supprimer un composant avant de comprendre son rôle

Une application système peut sembler inutile.

Pourtant elle peut :

- enregistrer un service Binder ;
- initialiser un pilote ;
- fournir une bibliothèque ;
- lancer un démon.

Avant toute suppression :

- comprendre ;
- documenter ;
- mesurer.

---

# 4. Ne jamais ignorer les journaux

Un bootloop n'est jamais une information suffisante.

Toujours consulter :

```
logcat

dmesg

tombstones
```

Les journaux permettent souvent de localiser immédiatement le composant en cause.

---

# 5. Ne jamais considérer une hypothèse comme un fait

Au cours du reverse engineering, il est fréquent de penser avoir compris le rôle d'un composant.

Pourtant :

```
Observation

≠

Conclusion
```

Chaque hypothèse doit être confirmée par :

- plusieurs observations ;
- des essais reproductibles ;
- une documentation.

---

# 6. Ne jamais désactiver une protection uniquement pour "faire fonctionner"

Exemple :

```
SELinux

↓

Permissive
```

ou

```
AVB

↓

Bypass
```

Ces modifications peuvent masquer le problème réel.

Le projet préfère identifier précisément la cause avant d'envisager une modification.

---

# 7. Ne jamais suivre aveuglément des tutoriels

Internet regorge de conseils.

Par exemple :

```
Modifier build.prop

↓

Plus rapide
```

ou

```
Supprimer telle APK

↓

Plus de RAM
```

Ces affirmations sont rarement accompagnées de mesures.

Dans HY300 Ultimate :

Chaque optimisation doit être démontrée.

---

# 8. Ne jamais oublier les sauvegardes

Avant chaque étape importante :

```
SHA-256

↓

Backup

↓

Git Commit

↓

Modification
```

Cette séquence a permis de restaurer rapidement plusieurs états du projet.

---

# 9. Ne jamais publier une build non validée

Une build doit avoir passé :

✓ validation des partitions

✓ validation des services

✓ validation fonctionnelle

✓ contrôle des journaux

✓ contrôle des performances

avant toute diffusion.

---

# 10. Ne jamais confondre stabilité et absence de crash

Un firmware peut :

- démarrer ;
- sembler fonctionnel ;
- cacher une fuite mémoire ;
- provoquer des erreurs après plusieurs heures.

Les tests doivent donc être réalisés dans la durée.

---

# Les erreurs réellement rencontrées pendant HY300 Ultimate

Le projet a mis en évidence plusieurs difficultés récurrentes.

## Gestion des partitions dynamiques

La reconstruction de `super.img` impose de respecter :

- les groupes LP ;
- les tailles des partitions ;
- les métadonnées.

Une simple erreur d'alignement peut empêcher la génération correcte de l'image.

---

## Gestion des images ext4

Une image démontée incorrectement peut devenir incohérente.

Les vérifications avec `e2fsck` avant chaque reconstruction se sont révélées indispensables.

---

## Environnement de développement

Les différences entre macOS, Linux et Docker ont nécessité une normalisation des outils, des permissions et des scripts afin de garantir la reproductibilité.

---

## Gestion des artefacts

Au fil du projet, plusieurs centaines de fichiers ont été produits :

- sauvegardes ;
- journaux ;
- images ;
- rapports ;
- scripts.

Une organisation stricte du dépôt Git s'est révélée essentielle pour conserver une vision claire de l'évolution du projet.

---

# Les règles de HY300 Ultimate

Au terme de cette étude, plusieurs règles sont devenues permanentes.

```
Toujours sauvegarder.

Toujours mesurer.

Toujours documenter.

Toujours comparer.

Toujours pouvoir revenir en arrière.

Toujours distinguer les faits des hypothèses.
```

Ces principes guident toutes les évolutions du firmware.

---

# Journal de développement

**Objectif**

Formaliser les bonnes pratiques acquises pendant le développement.

**Résultat**

Une méthodologie reproductible limitant fortement les erreurs de manipulation.

**Décision**

Ces règles seront appliquées à toutes les futures versions de HY300 Ultimate.

---

# Enseignements

Les plus grandes difficultés du projet n'ont pas été causées par Android lui-même.

Elles proviennent principalement :

- d'une mauvaise compréhension initiale de certains composants ;
- de la complexité des partitions dynamiques ;
- de l'importance des validations successives.

En adoptant une approche progressive, ces difficultés ont pu être surmontées sans compromettre les données d'origine.

---

# Conclusion

Le succès d'un projet de reverse engineering dépend autant de la discipline que des compétences techniques.

Les erreurs documentées dans ce chapitre ne sont pas spécifiques au HY300.

Elles concernent la majorité des projets de personnalisation de firmware Android.

En appliquant ces recommandations, il devient possible de réduire considérablement les risques, d'accélérer le débogage et de construire des firmwares plus fiables.

---

## Les dix règles d'or

|   N° | Règle                                   |
| ---: | --------------------------------------- |
|    1 | Toujours sauvegarder avant de modifier  |
|    2 | Une seule modification à la fois        |
|    3 | Comprendre avant de supprimer           |
|    4 | Lire les journaux système               |
|    5 | Distinguer observations et conclusions  |
|    6 | Respecter les mécanismes de sécurité    |
|    7 | Mesurer avant d'optimiser               |
|    8 | Conserver des empreintes SHA-256        |
|    9 | Ne publier qu'après validation complète |
|   10 | Documenter chaque décision technique    |

---

> [!WARNING]
> La plupart des erreurs coûteuses ne sont pas dues à des manipulations complexes, mais à des raccourcis pris trop tôt. La meilleure façon de gagner du temps est souvent d'investir quelques minutes supplémentaires dans une sauvegarde, une mesure ou une vérification avant toute modification.

---

# Chapitre suivant

➡️ **55 – Publication responsable : diffuser un firmware de manière éthique, documentée et reproductible**