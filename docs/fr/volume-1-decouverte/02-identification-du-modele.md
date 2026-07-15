---
title: "Identification exacte du modèle étudié"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 2 — Identifier précisément la plateforme étudiée

> *La première erreur d'un reverse engineer consiste à croire qu'il connaît déjà l'appareil qu'il analyse.*

---

# Introduction

Avant même d'exécuter une seule commande de reverse engineering, une question fondamentale devait être résolue.

**Quel appareil avons-nous réellement entre les mains ?**

Cette question peut sembler évidente.

Après tout, le projecteur est commercialisé sous le nom **HY300**.

Pourtant, cette désignation est essentiellement commerciale.

Dans l'univers Android OEM, un même nom peut désigner plusieurs révisions matérielles différentes, plusieurs firmwares incompatibles ou encore plusieurs variantes produites par des assembleurs distincts.

Autrement dit, connaître le nom imprimé sur l'emballage ne permet absolument pas de connaître l'architecture réelle de l'appareil.

Avant toute modification, il était donc indispensable de l'identifier avec précision.

---

# Pourquoi cette étape est essentielle

De nombreux guides publiés sur Internet supposent que tous les appareils portant le même nom sont identiques.

En pratique, cette hypothèse est fausse.

Deux projecteurs vendus sous la même référence peuvent présenter des différences importantes :

- processeur différent ;
- quantité de mémoire différente ;
- partitionnement différent ;
- pilotes différents ;
- mécanismes OTA incompatibles ;
- noyaux Linux différents ;
- applications OEM différentes.

Modifier un firmware destiné à une autre variante peut conduire à un appareil impossible à démarrer.

L'identification constitue donc la première mesure de sécurité de toute étude sérieuse.

---

# Méthodologie

Plutôt que de nous fier aux informations commerciales, nous avons choisi d'interroger directement le système Android.

Les premières commandes avaient un objectif très simple :

- identifier le SoC ;
- identifier la variante de la carte mère ;
- identifier la version exacte d'Android ;
- identifier le type de build ;
- identifier le partitionnement ;
- identifier les composants constructeur.

Cette approche présente un avantage majeur.

Elle repose exclusivement sur des informations fournies par le système lui-même.

---

# Le processeur

Les propriétés système ont confirmé que le projecteur repose sur un **Rockchip RK3326**.

Cette plateforme est largement utilisée dans les systèmes embarqués :

- consoles rétro ;
- box Android ;
- écrans interactifs ;
- systèmes industriels ;
- vidéoprojecteurs.

Le RK3326 embarque quatre cœurs ARM Cortex-A35 64 bits.

Il privilégie une faible consommation électrique plutôt que les performances brutes.

Ce choix est cohérent avec un appareil destiné à rester allumé pendant plusieurs heures.

---

# Une variante spécifique

L'une des découvertes les plus importantes concerne l'identifiant interne de la plateforme.

Au cours de l'analyse, plusieurs propriétés système et composants logiciels ont permis d'identifier la variante :

```
rk3326_sgo
```

Cette information est beaucoup plus intéressante que le simple nom « HY300 ».

Elle correspond à la véritable plateforme logicielle utilisée par le constructeur.

C'est cette référence qui devra être utilisée pour comparer d'autres firmwares ou rechercher des variantes compatibles.

---

# Android 12

Le système analysé exécute Android 12.

Cette information influence directement plusieurs éléments de l'architecture :

- partitions dynamiques ;
- organisation de `super.img` ;
- gestion des propriétés système ;
- composants APEX ;
- comportement de `init`.

Connaître précisément la version d'Android est indispensable pour interpréter correctement les fichiers système rencontrés par la suite.

---

# Une build userdebug

L'une des surprises les plus intéressantes de cette étude concerne le type de build utilisé.

Les propriétés système indiquent qu'il ne s'agit pas d'une build totalement verrouillée destinée au grand public.

Plusieurs indices montrent au contraire que le firmware est basé sur une variante **userdebug**.

Cette observation est importante.

Une build userdebug conserve généralement davantage d'outils de diagnostic que les builds « user » classiques.

Elle facilite le développement interne du constructeur.

Dans certains cas, elle peut également exposer davantage de fonctionnalités de débogage.

Cette caractéristique jouera un rôle essentiel dans les chapitres consacrés à ADB.

---

# Une architecture Android moderne

L'étude du partitionnement a rapidement montré que le constructeur utilise les mécanismes modernes introduits par Android.

Parmi les éléments identifiés :

- partition dynamique `super` ;
- partitions logiques `system`, `vendor`, `odm`, `product` ;
- `system_ext` ;
- `vendor_dlkm` ;
- `odm_dlkm`.

Cette organisation diffère fortement des anciens appareils Android.

Elle rend les mises à jour plus flexibles mais complique considérablement le travail de modification du firmware.

C'est précisément pour cette raison qu'un chapitre entier sera consacré à l'étude de `super.img`.

---

# Une plateforme orientée constructeur

Dès les premières explorations, plusieurs composants propriétaires ont attiré notre attention.

Parmi eux :

- des applications OEM spécifiques ;
- un moteur Keystone propriétaire ;
- plusieurs bibliothèques natives Rockchip ;
- différents services lancés très tôt pendant le démarrage.

Cette architecture montre clairement que la majorité des fonctionnalités spécifiques du projecteur ne proviennent pas directement d'Android.

Elles sont ajoutées par le constructeur sous forme de composants propriétaires.

Comprendre leurs interactions deviendra l'un des objectifs majeurs de cette étude.

---

# Ce que nous savons déjà

À ce stade de l'enquête, plusieurs éléments peuvent être considérés comme établis.

### Faits

- le projecteur repose sur un SoC Rockchip RK3326 ;
- la variante logicielle étudiée est identifiée comme `rk3326_sgo` ;
- le firmware est basé sur Android 12 ;
- le système utilise des partitions dynamiques ;
- plusieurs composants propriétaires sont intégrés au firmware.

### Déductions

L'utilisation d'une build de type userdebug suggère que le firmware conserve certains mécanismes de développement ou de diagnostic normalement absents d'une build strictement destinée à la production.

Cette observation est cohérente avec la facilité d'accès obtenue par ADB au cours de l'étude.

### Hypothèses

À ce stade, nous ne pouvons pas encore déterminer si cette configuration résulte d'un choix volontaire du constructeur, d'un oubli lors de la production ou d'une base logicielle commune réutilisée pour plusieurs appareils.

Les chapitres suivants apporteront progressivement des éléments de réponse.

---

# Conclusion

Identifier précisément la plateforme étudiée constitue la fondation de toute la suite de cette enquête.

Nous savons désormais que nous n'analysons pas simplement un « HY300 », mais une plateforme Android 12 basée sur le SoC Rockchip RK3326, reposant sur la variante logicielle `rk3326_sgo` et utilisant une architecture moderne de partitions dynamiques.

Cette identification nous fournit désormais un point de référence fiable.

La prochaine étape consiste à comprendre comment établir une première communication avec l'appareil sans modifier son fonctionnement.

Cette étape nous conduira à l'une des découvertes les plus inattendues de toute cette étude : **un démon ADB accessible sur un port réseau totalement inattendu**.

---

> [!IMPORTANT]
> Toutes les conclusions de ce chapitre concernent exclusivement la variante analysée au cours de cette étude. D'autres révisions matérielles commercialisées sous le nom HY300 peuvent présenter des différences importantes.