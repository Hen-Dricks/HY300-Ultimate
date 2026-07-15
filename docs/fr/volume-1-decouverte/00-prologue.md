---
title: "Prologue"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Prologue

> *« Chaque appareil électronique raconte une histoire. La plupart des utilisateurs ne la verront jamais. Ce livre est consacré à l'une d'entre elles. »*

---

## Avant-propos

Lorsque l'on évoque le reverse engineering d'Android, les premiers appareils qui viennent généralement à l'esprit sont les smartphones haut de gamme, les consoles de jeux, les téléviseurs connectés ou encore les objets connectés largement diffusés.

Les vidéoprojecteurs Android d'entrée de gamme sont rarement considérés comme des plateformes intéressantes pour la recherche.

Pourtant, ils représentent aujourd'hui un écosystème particulièrement riche.

Sous une interface utilisateur volontairement simplifiée se cache un système Android complet, composé de plusieurs centaines de services, bibliothèques, applications système, partitions, mécanismes de sécurité et composants propriétaires.

Le projecteur étudié dans cet ouvrage appartient précisément à cette catégorie.

Commercialisé sous différentes marques selon les marchés, il repose sur une plateforme Rockchip RK3326 exécutant Android 12 accompagné d'une importante couche logicielle développée par différents acteurs :

- Google (Android Open Source Project)
- Rockchip
- différents OEM
- différents ODM
- le fabricant final du projecteur

Ces différentes couches rendent l'analyse particulièrement intéressante.

---

## Pourquoi ce projet existe

L'idée initiale était extrêmement simple.

Comme beaucoup d'utilisateurs, nous souhaitions uniquement améliorer l'expérience d'utilisation du projecteur.

Les premiers constats étaient relativement classiques :

- une interface parfois lente ;
- un launcher peu ergonomique ;
- plusieurs applications constructeur dont l'utilité semblait limitée ;
- des performances variables selon les usages.

L'objectif était donc initialement de supprimer quelques applications préinstallées et d'installer un launcher alternatif plus agréable.

Quelques heures plus tard, cette idée avait totalement changé de nature.

Chaque réponse apportait de nouvelles questions.

Pourquoi certaines applications OEM semblaient-elles indispensables ?

Pourquoi la correction trapézoïdale semblait-elle largement dépasser le simple cadre d'une application Android ?

Pourquoi plusieurs composants système possédaient-ils des privilèges élevés ?

Pourquoi la plateforme semblait-elle reposer sur une build Android destinée au développement plutôt qu'à la production ?

Progressivement, il est devenu évident qu'optimiser le système sans comprendre son architecture reviendrait à modifier un mécanisme complexe à l'aveugle.

Le projet est alors devenu une véritable enquête de reverse engineering.

---

## Les objectifs

Contrairement à de nombreux projets communautaires consacrés aux appareils Android, ce travail ne poursuit pas uniquement un objectif de personnalisation.

Notre ambition est plus large.

Nous souhaitons comprendre précisément le fonctionnement interne de cette plateforme.

Pour cela, plusieurs axes d'étude ont été retenus :

- identification matérielle complète ;
- analyse de l'architecture Android ;
- étude des partitions ;
- reverse engineering des applications constructeur ;
- analyse du moteur Keystone ;
- étude des services privilégiés ;
- compréhension des mécanismes OTA ;
- reconstruction intégrale du firmware ;
- amélioration des performances tout en conservant les fonctionnalités essentielles.

Cette documentation n'est donc pas un simple guide d'installation.

Elle constitue un travail de recherche reproductible.

---

## Une méthodologie volontairement rigoureuse

L'ensemble de cette étude repose sur quelques principes simples.

Aucune modification n'est effectuée sans sauvegarde préalable.

Chaque partition importante est sauvegardée avant toute expérimentation.

Chaque image reconstruite est vérifiée par comparaison cryptographique.

Chaque résultat est reproduit plusieurs fois lorsque cela est possible.

Cette approche peut sembler particulièrement prudente.

Elle est pourtant indispensable.

Une expérimentation impossible à reproduire possède une valeur scientifique très limitée.

À l'inverse, une manipulation parfaitement documentée pourra être vérifiée plusieurs années plus tard par d'autres chercheurs.

---

## Faits, déductions et hypothèses

L'un des objectifs majeurs de cette publication consiste à éviter toute conclusion hâtive.

Dans le domaine de la sécurité, il est extrêmement fréquent de qualifier trop rapidement un composant inconnu de spyware ou de malware.

Cette étude adopte volontairement une approche beaucoup plus prudente.

Chaque conclusion appartient à l'une des trois catégories suivantes.

### Faits

Les faits correspondent exclusivement aux observations réalisées pendant l'étude.

Par exemple :

- un processus est exécuté avec les privilèges root ;
- une propriété Android change de valeur ;
- un binaire est recréé automatiquement après suppression.

Ces informations sont directement vérifiables.

### Déductions

Les déductions correspondent aux conclusions raisonnablement établies à partir des faits.

Par exemple, un processus qui recrée systématiquement un binaire supprimé possède vraisemblablement un mécanisme de persistance.

Cette conclusion découle directement des observations.

### Hypothèses

Enfin, certaines questions restent ouvertes.

Lorsqu'aucune preuve suffisante ne permet de confirmer un comportement, celui-ci est présenté comme une hypothèse et non comme un fait.

Cette distinction sera appliquée dans l'ensemble de cet ouvrage.

---

## Une documentation destinée à durer

Toutes les commandes utilisées au cours de cette enquête seront intégralement documentées.

Chaque résultat important sera accompagné :

- des commandes ayant permis de l'obtenir ;
- des sorties correspondantes ;
- de leur interprétation ;
- des éventuelles erreurs rencontrées ;
- des solutions retenues.

L'objectif est qu'un autre chercheur puisse reproduire l'ensemble de cette étude sans avoir à deviner les étapes intermédiaires.

---

## À qui s'adresse cet ouvrage ?

Cette documentation s'adresse principalement :

- aux développeurs Android ;
- aux chercheurs en sécurité ;
- aux passionnés de systèmes embarqués ;
- aux personnes souhaitant comprendre le fonctionnement interne des firmwares Android OEM.

Elle ne suppose pas une connaissance préalable du projecteur étudié.

Au contraire, chaque notion importante sera introduite progressivement.

---

## Une enquête avant tout

Ce livre ne doit pas être lu comme un simple tutoriel.

Il raconte une enquête technique.

Chaque découverte conduit naturellement à la suivante.

Chaque hypothèse est progressivement confirmée ou abandonnée.

Le lecteur suivra exactement le même cheminement intellectuel que celui ayant permis de comprendre progressivement le fonctionnement interne de cette plateforme.

Tout commence pourtant par une question très simple.

**Comment accéder au système ?**

La réponse à cette question ouvrira le premier chapitre de cette étude.

---

> [!NOTE]
> Les observations présentées dans cet ouvrage concernent la variante matérielle étudiée pendant cette recherche. D'autres révisions du HY300 peuvent présenter des différences importantes.

---

## Chapitre suivant

➡️ **01 – Contexte et objectifs**