---
title: "Validation bit à bit"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 45 — Validation bit à bit

> *« Une ROM ne devient pas fiable parce qu'elle démarre. Elle devient fiable lorsque chaque différence introduite est connue, documentée, expliquée et vérifiée. »*

---

# Introduction

La reconstruction de `super.img` marque la fin de la phase de développement.

Cependant, avant toute diffusion, une dernière étape est indispensable :

**la validation complète de l'image reconstruite.**

L'objectif n'est pas uniquement de vérifier que le projecteur démarre.

Il s'agit de démontrer que :

- seules les modifications prévues ont été introduites ;
- aucune corruption n'est apparue ;
- les partitions restent cohérentes ;
- le firmware demeure stable.

Cette validation constitue le dernier rempart avant la publication d'une nouvelle build.

---

# Philosophie

Le projet HY300 Ultimate repose sur un principe simple.

Chaque modification doit être :

- mesurable ;
- vérifiable ;
- reproductible ;
- documentée.

Une modification non documentée est considérée comme une anomalie.

---

# Les cinq niveaux de validation

La validation est organisée selon cinq niveaux complémentaires.

```
Image

↓

Partitions

↓

Fichiers

↓

Services

↓

Fonctions utilisateur
```

Chaque niveau doit être validé avant de passer au suivant.

---

# Niveau 1 — Validation de l'image

Nous vérifions :

- taille finale ;
- intégrité ;
- empreinte SHA-256 ;
- compatibilité avec `lpunpack`.

Commande :

```bash
sha256sum super-hy300-ultimate.img
```

Le résultat est archivé.

---

# Niveau 2 — Validation des partitions

Les partitions sont réextraites.

```bash
lpunpack super-hy300-ultimate.img extracted/
```

Chaque image obtenue est ensuite contrôlée.

```bash
e2fsck -f system.img

e2fsck -f vendor.img
```

Aucune erreur ne doit être détectée.

---

# Niveau 3 — Validation des fichiers

Les différences entre le firmware constructeur et HY300 Ultimate sont comparées.

Exemple :

```bash
diff -ruN

system-original/

system-hy300-ultimate/
```

Les modifications sont ensuite classées.

---

## Nouveaux composants

Exemple :

- Projectivy Launcher

---

## Composants supprimés

Exemple :

- applications OEM retirées

---

## Composants modifiés

Exemple :

- `build.prop`
- scripts de démarrage
- fichiers XML
- configuration système

Chaque différence est justifiée dans la documentation.

---

# Niveau 4 — Validation des services

Le système est démarré.

Nous vérifions ensuite :

```bash
adb shell service list
```

Puis :

```bash
adb shell ps -A
```

Objectifs :

- vérifier les services critiques ;
- identifier d'éventuels crashs ;
- détecter des redémarrages en boucle.

---

# Niveau 5 — Validation fonctionnelle

La dernière étape consiste à utiliser réellement le projecteur.

Checklist.

| Fonction           | Résultat |
| ------------------ | -------- |
| Boot Android       | ☐        |
| Launcher           | ☐        |
| Wi-Fi              | ☐        |
| Bluetooth          | ☐        |
| Keystone           | ☐        |
| Autofocus          | ☐        |
| HDMI               | ☐        |
| Lecture vidéo      | ☐        |
| USB                | ☐        |
| Audio              | ☐        |
| Paramètres Android | ☐        |
| Mise en veille     | ☐        |
| Réveil             | ☐        |

Cette grille sera complétée pour chaque build.

---

# Validation des performances

Les performances sont comparées au firmware constructeur.

Les indicateurs suivis sont :

- temps de démarrage ;
- mémoire utilisée ;
- occupation CPU ;
- espace libre ;
- fluidité de l'interface.

Les résultats sont consignés afin de mesurer l'impact réel des optimisations.

---

# Analyse des journaux

Pendant les essais, les journaux Android sont enregistrés.

```bash
adb logcat -b all
```

Ainsi que les journaux du noyau.

```bash
adb shell dmesg
```

Les objectifs sont :

- identifier les erreurs ;
- repérer les services absents ;
- détecter les avertissements répétés.

---

# Comparaison des empreintes

Chaque build reçoit une nouvelle empreinte.

Exemple.

| Élément              | SHA-256 |
| -------------------- | ------- |
| super-original.img   | ...     |
| super-hy300-v0.1.img | ...     |
| super-hy300-v0.2.img | ...     |

Cela garantit la traçabilité complète des versions.

---

# Rapport de validation

Chaque build est accompagnée d'un rapport.

Exemple :

```
Version

↓

HY300 Ultimate v0.2

Base firmware

↓

HY300 OEM

SHA-256

↓

...

Boot

↓

OK

Launcher

↓

Projectivy

Wi-Fi

↓

OK

Bluetooth

↓

OK

Keystone

↓

OK

Autofocus

↓

OK

Applications OEM supprimées

↓

4

Services neutralisés

↓

1

Problèmes connus

↓

Aucun
```

Ce rapport sera publié avec chaque version.

---

# Validation de la reproductibilité

Une exigence fondamentale du projet est qu'un autre chercheur puisse reconstruire exactement la même build.

Pour cela, le dépôt contient :

- les scripts ;
- les commandes ;
- les paramètres de reconstruction ;
- les empreintes ;
- les journaux.

Cette approche garantit la reproductibilité scientifique du projet.

---

# Journal de développement

**Objectif**

Valider l'intégrité complète de la build HY300 Ultimate.

**Résultat**

Validation en cours.

Les rapports seront enrichis après chaque nouvelle version testée sur le matériel.

**Décision**

Aucune build ne sera publiée sans avoir passé l'ensemble des niveaux de validation décrits dans ce chapitre.

---

# Enseignements

La validation est souvent l'étape la plus sous-estimée dans les projets de ROM personnalisées.

Pourtant, elle conditionne directement la fiabilité du firmware.

Une build qui démarre n'est pas nécessairement une build stable.

Seule une validation méthodique permet de garantir que les modifications apportées ne dégradent pas le fonctionnement général du système.

---

# Conclusion

La validation bit à bit constitue la dernière étape du cycle de développement de HY300 Ultimate.

Elle permet de démontrer que le firmware modifié reste cohérent avec son architecture d'origine tout en intégrant les améliorations souhaitées.

Grâce à cette approche, chaque version publiée pourra être auditée, comparée et reproduite par la communauté.

---

> [!IMPORTANT]
> La validation d'une build ne repose jamais sur une seule observation. Elle combine des contrôles d'intégrité, des comparaisons de fichiers, des analyses de journaux, des essais fonctionnels et des mesures de performances. C'est cette accumulation de preuves qui permet de qualifier une version comme suffisamment stable pour être diffusée.

---

# Chapitre suivant

➡️ **46 – Releases v0.1 et v0.2 : historique des builds, évolutions et retours d'expérience**