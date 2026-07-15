---
title: "Android, Recovery et Fastboot"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 6 — Android, Recovery et Fastboot

> *Le plus difficile n'est pas de trouver un mode de démarrage. Le plus difficile est de comprendre ce qu'il permet réellement de faire.*

---

# Introduction

Après avoir obtenu un accès ADB complet au système Android, une question s'est rapidement imposée.

**Comment allions-nous restaurer l'appareil si une modification rendait le système inutilisable ?**

Cette question peut sembler prématurée.

Elle est pourtant essentielle.

Tout travail sérieux de reverse engineering commence par prévoir un chemin de retour.

Modifier un firmware sans stratégie de restauration revient à expérimenter sans filet de sécurité.

Avant même d'extraire une partition ou de supprimer une application système, nous avons donc entrepris de cartographier les différents modes de démarrage proposés par le projecteur.

Très rapidement, trois environnements distincts sont apparus :

- Android ;
- Recovery ;
- Fastboot.

Sur le papier, cette organisation est classique.

En pratique, chacun de ces environnements s'est comporté très différemment.

---

# Android : l'environnement de travail principal

Le premier environnement est naturellement Android lui-même.

C'est dans ce mode que nous avons découvert le démon ADB exposé sur le port TCP 3268.

Une fois connecté, nous avons pu :

- obtenir un shell ;
- redémarrer `adbd` avec les privilèges root ;
- interroger les propriétés système ;
- examiner les partitions ;
- sauvegarder les images du firmware.

Android est rapidement devenu notre environnement principal de travail.

Il présentait deux avantages majeurs.

Premièrement, le système était complètement fonctionnel.

Deuxièmement, l'accès ADB permettait déjà d'effectuer la majorité des opérations d'analyse sans aucune modification matérielle.

À ce stade, rien ne justifiait encore l'utilisation du Recovery.

---

# Recovery : un environnement plus minimaliste

Le second mode étudié fut le Recovery.

Contrairement à Android, cet environnement ne lance pas l'ensemble des services utilisateur.

Son objectif principal est de permettre :

- la maintenance du système ;
- l'installation de mises à jour ;
- certaines opérations de restauration.

Nous avons vérifié que le projecteur démarrait correctement dans ce mode.

Cette validation était importante.

Elle constituait une première garantie qu'un mécanisme de récupération restait disponible en cas de problème.

Cependant, plusieurs différences sont rapidement apparues.

Le comportement réseau n'était plus identique.

ADB ne se comportait plus exactement comme sous Android.

Les services actifs étaient beaucoup moins nombreux.

Autrement dit, le Recovery n'était pas simplement Android avec une interface différente.

Il s'agissait d'un environnement spécifique possédant sa propre logique de fonctionnement.

---

# Fastboot : une surprise inattendue

Le troisième environnement étudié fut Fastboot.

Les premiers indices étaient encourageants.

Le projecteur proposait explicitement une option permettant de démarrer dans ce mode.

Tout semblait donc indiquer que nous allions disposer du mécanisme classique utilisé sur de nombreux appareils Android pour flasher les partitions.

Nous avons alors préparé notre poste de travail.

Le client Fastboot était installé.

Les commandes étaient prêtes.

Le projecteur affichait clairement son écran Fastboot.

Tout semblait réuni.

Pourtant…

Rien ne se produisit.

---

# Un périphérique invisible

La première commande exécutée fut volontairement simple.

```bash
fastboot devices
```

Le résultat fut particulièrement surprenant.

Aucun appareil.

La commande ne retournait absolument rien.

Nous avons immédiatement envisagé plusieurs explications.

Le câble était-il défectueux ?

Le port USB était-il mal reconnu ?

Le Mac détectait-il seulement un nouveau périphérique ?

Pour répondre à cette dernière question, nous avons examiné directement les périphériques USB visibles par macOS.

Là encore, aucune trace du projecteur.

---

# Une contradiction apparente

Cette situation était particulièrement déroutante.

Le projecteur affichait un écran Fastboot.

Le système Android mentionnait plusieurs propriétés faisant référence à Fastboot.

Les raisons de démarrage (`bootreason`) confirmaient également des redémarrages dans ce mode.

Pourtant, du point de vue de l'ordinateur, aucun périphérique Fastboot n'existait.

Cette contradiction constitue probablement l'un des moments les plus intéressants de toute l'enquête.

Elle rappelle une règle importante.

**Ce que l'interface utilisateur affiche ne correspond pas nécessairement à ce qui est réellement exposé sur le bus USB.**

Autrement dit, un menu intitulé *Fastboot* n'implique pas automatiquement qu'une interface Fastboot standard soit disponible.

---

# Plusieurs hypothèses

Face à cette situation, plusieurs scénarios ont été envisagés.

Le premier consistait à supposer une incompatibilité matérielle.

Le connecteur USB utilisé par le projecteur pourrait ne pas être câblé pour le transfert de données.

Le second concernait le contrôleur USB lui-même.

Il est possible que le firmware n'active tout simplement pas la pile USB nécessaire au protocole Fastboot.

Une troisième hypothèse concernait le câble utilisé.

Plusieurs essais ont été réalisés avec différents câbles afin d'écarter cette possibilité.

Aucun ne modifia le comportement observé.

À ce stade, aucune conclusion définitive ne pouvait être tirée.

En revanche, un fait demeurait incontestable :

**nous ne disposions pas d'un accès Fastboot exploitable.**

---

# Changer de stratégie

Cette découverte aurait pu bloquer complètement le projet.

Au lieu de cela, elle nous a conduits à repenser notre méthode de travail.

Puisque Fastboot n'était pas disponible dans des conditions normales, il devenait indispensable d'exploiter au maximum les possibilités offertes par Android lui-même.

Cette décision allait profondément influencer toute la suite de l'enquête.

Plutôt que de flasher directement des partitions via Fastboot, nous avons choisi une approche plus prudente.

Chaque partition importante serait :

1. sauvegardée ;
2. vérifiée par SHA-256 ;
3. reconstruite hors de l'appareil ;
4. comparée bit à bit ;
5. restaurée uniquement après validation complète.

Cette stratégie s'est révélée beaucoup plus fiable que prévu.

---

# Une conséquence inattendue

Paradoxalement, l'absence de Fastboot a amélioré la qualité de notre documentation.

Nous avons été contraints de comprendre beaucoup plus précisément le fonctionnement du firmware.

Nous avons appris à manipuler les partitions dynamiques.

Nous avons documenté la reconstruction de `super.img`.

Nous avons développé des procédures de validation reposant sur des comparaisons cryptographiques.

Autrement dit, une difficulté technique s'est progressivement transformée en avantage méthodologique.

---

# Ce que nous savons désormais

## Faits

- Android fournit un accès ADB complet.
- Le Recovery fonctionne correctement.
- Le mode Fastboot est accessible depuis le projecteur.
- Aucun périphérique Fastboot standard n'a été détecté par notre station de travail malgré plusieurs essais.

## Déductions

Le simple affichage d'un écran Fastboot ne garantit pas la présence d'une interface USB compatible avec les outils Fastboot classiques.

Une stratégie de restauration ne peut donc pas reposer exclusivement sur cette fonctionnalité.

## Hypothèses

Il reste possible que certaines variantes matérielles du HY300 exposent une interface Fastboot pleinement fonctionnelle.

Il est également envisageable qu'un mode Loader Rockchip permette un accès plus bas niveau.

Ces pistes feront l'objet de travaux futurs.

---

# Conclusion

L'étude des différents modes de démarrage nous a enseigné une leçon essentielle.

Dans le monde des appareils Android OEM, les appellations ne suffisent pas.

Un mode Recovery n'est pas nécessairement identique à celui d'un smartphone Android.

Un mode Fastboot n'est pas nécessairement utilisable avec l'outil `fastboot`.

Ces différences expliquent pourquoi la sauvegarde complète des partitions est rapidement devenue la pierre angulaire de notre méthodologie.

Avant toute modification, il fallait désormais garantir une restauration intégrale du système.

Le chapitre suivant marquera une nouvelle étape.

Nous commencerons à raconter chronologiquement toute l'enquête, depuis les premières commandes jusqu'à la reconstruction complète du firmware, afin de donner au lecteur une vision globale du cheminement suivi.

---

> [!IMPORTANT]
> Les observations décrites dans ce chapitre correspondent exclusivement au comportement de la variante matérielle étudiée et à la configuration logicielle analysée. Elles ne doivent pas être généralisées à l'ensemble des appareils commercialisés sous le nom HY300.