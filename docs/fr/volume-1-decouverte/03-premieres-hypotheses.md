---
title: "Premières hypothèses"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 3 — Les premières hypothèses

> *Une enquête technique ne commence jamais par des certitudes. Elle commence par des hypothèses que l'on cherche ensuite à invalider.*

---

# Introduction

À ce stade de l'étude, nous connaissons désormais l'identité de la plateforme.

Nous savons qu'il s'agit d'un projecteur Android 12 reposant sur un SoC Rockchip RK3326 et utilisant une architecture moderne de partitions dynamiques.

Nous ne savons cependant toujours pas comment le constructeur a organisé son firmware.

Nous ignorons :

- quelles applications sont réellement indispensables ;
- comment fonctionne la correction trapézoïdale ;
- où sont stockés les paramètres de calibration ;
- comment le système démarre ;
- quels services communiquent entre eux ;
- comment accéder proprement au système sans commencer immédiatement à modifier des partitions.

Avant d'effectuer la moindre manipulation invasive, il fallait répondre à une question beaucoup plus simple.

**Comment observer le système sans le perturber ?**

---

# Première hypothèse

La première hypothèse était volontairement conservatrice.

Nous avons supposé que le constructeur avait laissé les mécanismes classiques de développement Android relativement intacts.

Dans cette hypothèse, plusieurs possibilités existaient.

Le débogage ADB pouvait être :

- complètement désactivé ;
- limité au port USB ;
- accessible uniquement après activation des options développeur ;
- disponible directement sur le réseau.

Cette dernière possibilité paraissait relativement improbable.

Sur la majorité des appareils Android commerciaux, ADB TCP est désactivé par défaut.

Lorsqu'il est activé, il écoute presque toujours sur le port **5555**.

Nous avons donc commencé par cette hypothèse.

---

# Deuxième hypothèse

Une autre possibilité concernait les applications constructeur.

Le projecteur embarquait manifestement plusieurs composants OEM.

Il était donc envisageable que certains d'entre eux assurent eux-mêmes une interface d'administration distante.

Dans ce cas, le constructeur aurait pu :

- utiliser un port propriétaire ;
- encapsuler ADB derrière un proxy ;
- utiliser un démon entièrement différent.

Aucune preuve ne permettait encore de privilégier l'une de ces hypothèses.

---

# Troisième hypothèse

Nous avons également envisagé que le constructeur ait complètement supprimé toute possibilité de débogage.

Cette hypothèse aurait rendu le projet beaucoup plus complexe.

Dans ce scénario, plusieurs solutions auraient dû être envisagées :

- ouverture physique du projecteur ;
- recherche d'un port UART ;
- exploitation du mode Loader Rockchip ;
- utilisation d'un câble USB OTG si celui-ci était supporté.

Ces méthodes sont nettement plus intrusives.

Avant d'en arriver là, il était indispensable d'explorer toutes les possibilités offertes par le firmware lui-même.

---

# Une règle importante

À partir de ce moment précis, une règle simple a guidé toute l'enquête.

**Toujours privilégier la méthode la moins intrusive.**

Cette philosophie présente plusieurs avantages.

Elle limite les risques de rendre l'appareil inutilisable.

Elle évite de modifier les éléments que l'on cherche précisément à observer.

Elle permet également de documenter une procédure reproductible par d'autres utilisateurs ne disposant pas d'outillage spécialisé.

---

# Observer avant d'agir

Plutôt que de lancer immédiatement des outils de reverse engineering, nous avons commencé par observer le comportement général du projecteur.

Plusieurs éléments attiraient déjà l'attention.

Le système semblait particulièrement bavard dans certains journaux.

Les services constructeur démarraient très tôt.

Les fonctions de correction trapézoïdale semblaient communiquer avec des composants natifs.

Rien ne permettait encore de comprendre leur fonctionnement.

Mais une chose devenait claire.

Le firmware semblait beaucoup plus riche que prévu.

---

# Les premières tentatives

Les premières expérimentations furent volontairement simples.

Nous avons tenté les méthodes les plus classiques utilisées sur Android.

Connexion USB.

Connexion ADB.

Recherche des options développeur.

Activation du débogage.

Connexion réseau.

Certaines tentatives échouèrent immédiatement.

D'autres produisirent des résultats inattendus.

Ces premiers échecs furent loin d'être inutiles.

Au contraire.

Ils permirent progressivement d'éliminer plusieurs hypothèses.

Chaque réponse négative réduisait l'espace des possibilités.

---

# Une découverte inattendue

À ce stade, une idée commença à émerger.

Et si le constructeur n'avait pas supprimé ADB…

…mais simplement déplacé son point d'écoute ?

Cette hypothèse pouvait sembler étrange.

Pourquoi utiliser un autre port que 5555 ?

Pourtant, plusieurs fabricants OEM modifient volontairement certains paramètres de développement afin d'éviter qu'un simple balayage réseau révèle immédiatement un démon ADB actif.

Il devenait alors nécessaire de changer complètement de stratégie.

Au lieu de chercher un service précis sur un port connu…

…nous allions chercher **tous les services exposés par le projecteur**.

Cette décision allait conduire à l'une des découvertes les plus importantes de toute cette enquête.

---

# Ce que nous savons à ce stade

## Faits

- nous connaissons la plateforme matérielle ;
- nous n'avons encore effectué aucune modification système ;
- plusieurs méthodes d'accès restent possibles ;
- aucune hypothèse n'a encore été validée.

## Déductions

Le firmware paraît suffisamment complexe pour justifier une approche progressive.

Une simple suppression d'applications pourrait casser des fonctionnalités essentielles.

## Hypothèses

Le constructeur pourrait avoir déplacé certains services de développement sur des ports non conventionnels.

Cette hypothèse devra être vérifiée expérimentalement.

---

# Conclusion

Les premières heures d'une enquête sont souvent les plus frustrantes.

Les réponses sont rares.

Les hypothèses sont nombreuses.

Pourtant, c'est précisément à ce moment que se construit la méthodologie.

Nous avons volontairement résisté à la tentation de modifier le système.

À la place, nous avons décidé d'écouter le réseau.

Cette décision allait complètement changer la suite de l'étude.

Le prochain chapitre racontera comment un simple scan Nmap permit de découvrir un service inattendu sur le port **3268**, ouvrant ainsi l'accès à l'ensemble du firmware.

---

> [!NOTE]
> Aucune partition n'a été modifiée au cours des étapes décrites dans ce chapitre. Toutes les observations ont été réalisées de manière non intrusive.