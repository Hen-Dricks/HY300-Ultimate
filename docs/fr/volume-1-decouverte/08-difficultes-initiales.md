---
title: "Les difficultés initiales"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 8 — Les difficultés initiales

> *« Les échecs documentés sont souvent plus utiles que les réussites. Ils montrent non seulement ce qui fonctionne, mais aussi pourquoi les autres approches ont été abandonnées. »*

---

# Introduction

En parcourant les chapitres précédents, il serait facile de croire que cette enquête s'est déroulée de manière parfaitement linéaire.

Nous avons identifié le matériel.

Nous avons découvert ADB.

Nous avons obtenu un accès root.

Puis nous avons commencé à analyser le firmware.

La réalité fut très différente.

Cette étude a été ponctuée de nombreuses difficultés techniques.

Certaines étaient prévisibles.

D'autres étaient totalement inattendues.

Plusieurs jours ont parfois été nécessaires pour comprendre qu'une hypothèse pourtant raisonnable était fausse.

L'objectif de ce chapitre est précisément de documenter ces obstacles.

Non pas pour raconter les difficultés rencontrées, mais pour éviter que d'autres chercheurs reproduisent les mêmes erreurs.

---

# Première difficulté : un appareil très peu documenté

Avant même d'exécuter la moindre commande, un premier problème est apparu.

Le HY300 est largement vendu.

Pourtant, sa documentation technique est pratiquement inexistante.

Les résultats disponibles sur Internet concernent essentiellement :

- des fiches commerciales ;
- des vidéos de démonstration ;
- quelques tutoriels destinés aux utilisateurs.

En revanche, il est extrêmement difficile de trouver des informations fiables concernant :

- l'architecture interne ;
- le partitionnement ;
- les applications OEM ;
- le processus de démarrage ;
- les mécanismes OTA ;
- les composants propriétaires.

Cette absence de documentation a eu une conséquence immédiate.

Nous ne pouvions faire confiance à aucune hypothèse.

Tout devait être vérifié expérimentalement.

---

# Deuxième difficulté : distinguer les variantes

Le nom commercial « HY300 » laisse penser qu'il existe un seul modèle.

En réalité, plusieurs révisions matérielles semblent coexister.

Certaines différences peuvent concerner :

- le firmware ;
- les pilotes ;
- les applications constructeur ;
- les mécanismes de mise à jour.

Cette constatation nous a conduits à documenter systématiquement la variante étudiée.

Chaque conclusion de cet ouvrage doit être replacée dans ce contexte.

---

# Troisième difficulté : Fastboot

Le mode Fastboot représentait initialement notre principale stratégie de restauration.

Le raisonnement semblait logique.

Si l'appareil propose un menu Fastboot, il devrait être possible d'utiliser les outils Android classiques.

Les premiers essais ont pourtant montré une situation beaucoup plus ambiguë.

Le projecteur affichait correctement son écran Fastboot.

Le client `fastboot` était installé sur la station de travail.

Pourtant, aucune commande ne détectait l'appareil.

```bash
fastboot devices
```

Résultat :

```text
<aucun périphérique>
```

Nous avons immédiatement envisagé plusieurs explications.

Le câble.

Le connecteur.

Le contrôleur USB.

Le système d'exploitation.

Les pilotes.

Aucune de ces pistes n'a permis d'expliquer complètement le phénomène.

---

# Une erreur fréquente

Cette expérience nous a rappelé une règle importante.

Un menu Fastboot ne garantit pas l'existence d'une interface Fastboot exploitable.

L'interface graphique visible à l'écran n'est qu'une partie du système.

Encore faut-il que le firmware initialise correctement la pile USB nécessaire au protocole Fastboot.

Dans notre cas, cette étape semblait absente ou incomplète.

---

# Quatrième difficulté : les outils Android

Une autre difficulté est apparue au moment de commencer l'analyse des APK.

Nous souhaitions utiliser plusieurs outils classiques.

Parmi eux :

- `aapt`
- `apkanalyzer`
- `jadx`

Nous avons rapidement constaté que certains n'étaient pas présents dans l'environnement Docker utilisé pour le projet.

Par exemple :

```text
bash: aapt: command not found
```

ou encore :

```text
bash: apkanalyzer: command not found
```

Ces messages peuvent sembler anodins.

Ils indiquent pourtant que l'environnement de travail n'est pas encore prêt.

Au lieu de forcer les manipulations, nous avons choisi d'améliorer progressivement notre chaîne d'outils.

---

# Cinquième difficulté : JADX

L'étape suivante consistait à décompiler plusieurs applications système.

Là encore, une difficulté inattendue apparut.

Le chemin prévu pour `jadx` n'existait pas dans notre conteneur.

```text
/workspace/tools/jadx/bin/jadx

No such file or directory
```

Ce problème aurait pu être résolu rapidement en modifiant plusieurs scripts.

Nous avons préféré comprendre précisément pourquoi l'outil n'était pas disponible.

Cette approche plus lente s'est révélée bénéfique pour la reproductibilité de toute la chaîne de travail.

---

# Sixième difficulté : reconstruire super.img

L'un des défis majeurs de cette étude concernait la reconstruction de la partition dynamique `super`.

Android 12 repose sur un partitionnement moderne utilisant :

- `lpmake`
- `lpunpack`
- les partitions logiques
- les métadonnées dynamiques

Ces mécanismes sont puissants.

Ils rendent également les erreurs beaucoup plus difficiles à diagnostiquer.

Une simple taille incorrecte peut empêcher complètement le démarrage du système.

Pour cette raison, chaque reconstruction fut systématiquement validée.

---

# Septième difficulté : Git et macOS

Un problème beaucoup plus inhabituel est apparu lors de la compilation de certains outils Android.

Plusieurs fichiers présents dans le dépôt Git ne différaient que par la casse de leur nom.

Cette situation est parfaitement valide sous Linux.

Elle devient problématique sur la plupart des systèmes de fichiers utilisés par macOS.

Git refusait alors certains changements de branche.

Cette difficulté nous a finalement conduits à déplacer une partie du travail dans un environnement Linux isolé.

---

# Huitième difficulté : la patience

La dernière difficulté mérite probablement d'être mentionnée.

Elle ne concerne ni Android.

Ni Docker.

Ni Git.

Elle concerne la méthodologie elle-même.

À plusieurs reprises, il aurait été possible de gagner du temps en supprimant immédiatement certaines applications système.

Nous avons systématiquement refusé cette approche.

Chaque fois qu'un doute apparaissait, nous revenions à la même règle.

Observer.

Documenter.

Sauvegarder.

Puis seulement modifier.

Cette discipline explique en grande partie pourquoi l'appareil est resté récupérable pendant toute la durée du projet.

---

# Les enseignements

En relisant cette liste, une conclusion apparaît clairement.

Aucune de ces difficultés n'était réellement liée au projecteur lui-même.

La plupart provenaient :

- d'hypothèses initiales erronées ;
- de différences entre Android standard et les implémentations OEM ;
- de limitations des outils disponibles ;
- des particularités de notre environnement de développement.

Autrement dit, le reverse engineering ne consiste pas uniquement à comprendre un appareil.

Il consiste également à construire progressivement les bons outils pour l'étudier.

---

# Conclusion

Ces difficultés ont profondément influencé la méthodologie de l'ensemble du projet.

Sans elles, nous aurions probablement adopté une approche beaucoup plus classique.

Au contraire, elles nous ont conduits à :

- sauvegarder avant toute modification ;
- vérifier chaque image reconstruite ;
- comparer systématiquement les résultats ;
- documenter toutes les erreurs.

Cette philosophie restera présente dans tous les volumes suivants.

Le prochain chapitre clôturera cette première partie en résumant les enseignements de la phase de découverte avant d'entrer dans l'analyse détaillée de l'architecture Android.

---

> [!TIP]
> Les difficultés rencontrées ne doivent jamais être supprimées d'une documentation technique. Elles constituent souvent la partie la plus précieuse pour les chercheurs qui tenteront de reproduire le même travail.