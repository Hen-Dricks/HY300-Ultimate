---
title: "Chronologie de l'enquête"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 7 — Chronologie de l'enquête

> *« Les résultats d'une recherche sont importants. Le chemin qui y conduit l'est tout autant. »*

---

# Pourquoi une chronologie ?

Une grande partie des publications techniques se contente de présenter le résultat final.

Le lecteur découvre un firmware modifié, un script fonctionnel ou un exploit prêt à l'emploi, sans jamais comprendre comment l'auteur est arrivé à cette conclusion.

Cette approche présente un inconvénient majeur.

Elle donne l'impression que les découvertes apparaissent spontanément.

En réalité, un projet de reverse engineering progresse rarement de manière linéaire.

Il avance par hypothèses, essais, erreurs, validations et parfois retours en arrière.

Cette chronologie a pour objectif de montrer exactement ce cheminement.

---

# Jour 1 — La curiosité

L'objectif initial était extrêmement simple.

Nous voulions uniquement rendre le projecteur plus agréable à utiliser.

Les premières constatations furent classiques :

- interface parfois lente ;
- nombreuses applications préinstallées ;
- launcher constructeur limité ;
- comportement parfois difficile à expliquer.

À ce stade, rien ne laissait présager que plusieurs semaines de recherche allaient suivre.

---

## Première décision

> **Ne rien supprimer immédiatement.**

Cette décision paraît anodine.

Elle constitue pourtant probablement la meilleure décision prise pendant toute cette étude.

Il aurait été très facile de désinstaller plusieurs applications OEM.

Nous avons préféré comprendre leur rôle avant toute modification.

Avec le recul, cette décision s'est révélée déterminante.

---

# Jour 2 — Identification de la plateforme

Une fois les premières observations réalisées, nous avons entrepris d'identifier précisément l'appareil.

Les informations commerciales ne suffisaient pas.

Nous avons donc commencé à interroger directement Android.

Plusieurs propriétés système furent collectées.

Nous avons notamment identifié :

- Android 12 ;
- la plateforme Rockchip RK3326 ;
- la variante logicielle `rk3326_sgo` ;
- une architecture reposant sur des partitions dynamiques.

Cette étape permit de confirmer que nous n'étudions pas simplement un projecteur Android générique.

Nous étudiions une plateforme OEM bien spécifique.

---

# Jour 3 — La recherche d'ADB

Une question devenait centrale.

Comment communiquer proprement avec le système ?

Notre première intuition fut naturellement de tester le port TCP 5555.

Aucun résultat.

Plutôt que d'insister, nous avons changé d'approche.

Nous avons décidé de laisser le réseau parler.

---

### Encadré technique

```bash
nmap -Pn -sV <adresse_ip_du_projecteur>
```

**Objectif**

Découvrir les services réellement exposés par l'appareil, sans présumer de leur emplacement.

---

### Résultat inattendu

Un unique port attira immédiatement notre attention.

```text
3268/tcp open  globalcatLDAP?
```

À première vue, rien ne semblait relier ce résultat à Android.

Pourtant, cette ligne allait complètement changer la suite de l'étude.

---

# Jour 4 — Vérification

Plutôt que de faire confiance à Nmap, nous avons décidé de tester directement le protocole ADB.

La commande suivante fut exécutée.

```bash
adb connect <adresse_ip>:3268
```

Quelques secondes plus tard :

```text
connected to ...
```

Cette réponse suffisait à invalider l'hypothèse LDAP.

Le port 3268 hébergeait bien un démon Android Debug Bridge.

---

## Une nouvelle question

Découvrir ADB constituait déjà une excellente nouvelle.

Mais une interrogation plus importante apparaissait immédiatement.

Quels privilèges possédait ce démon ?

---

# Jour 5 — Une surprise

Nous avons exécuté une commande très classique.

```bash
adb root
```

Sur un smartphone Android classique, cette commande échoue presque toujours.

Le résultat obtenu fut pourtant le suivant.

```text
restarting adbd as root
```

Ce simple message changeait complètement la nature du projet.

Nous disposions désormais d'un accès root officiel fourni par le démon ADB lui-même.

---

# Jour 6 — Cartographie

Avant toute modification, une règle fut adoptée.

Aucune partition ne serait écrite tant que nous ne disposerions pas d'une sauvegarde complète.

Cette décision entraîna plusieurs jours de cartographie.

Nous avons identifié :

- les partitions ;
- les services ;
- les applications OEM ;
- les bibliothèques ;
- les mécanismes de démarrage ;
- les composants graphiques.

Cette phase représente la fondation scientifique de tout le projet.

---

# Jour 7 — Les premières découvertes OEM

Au fur et à mesure des explorations, plusieurs applications constructeur attirèrent notre attention.

Parmi elles :

- composants OTA ;
- outils de diagnostic ;
- launcher ;
- applications de projection ;
- services privilégiés.

À ce stade, nous ignorions encore leur rôle exact.

Une chose devenait néanmoins évidente.

Le constructeur avait ajouté une quantité importante de logique métier au-dessus d'Android.

---

# Jour 8 — Keystone

L'analyse des propriétés système révéla progressivement un mécanisme complexe de correction trapézoïdale.

Contrairement à notre hypothèse initiale, cette fonctionnalité ne reposait pas uniquement sur une application Android.

Elle impliquait :

- des propriétés persistantes ;
- des bibliothèques natives ;
- SurfaceFlinger ;
- plusieurs composants OEM.

Cette découverte ouvrit un nouveau champ de recherche.

---

# Jour 9 — daemon12138

L'apparition d'un processus particulier allait devenir l'un des sujets majeurs de cette étude.

Ce service présentait plusieurs caractéristiques inhabituelles :

- privilèges élevés ;
- interaction avec `/data/adb` ;
- comportement persistant.

À ce stade, nous avons volontairement refusé toute conclusion hâtive.

Le rôle exact de ce composant devait être démontré expérimentalement.

---

# Jour 10 — Sauvegarde intégrale

Avant toute modification importante, l'intégralité des partitions critiques fut sauvegardée.

Chaque image fut :

- extraite ;
- archivée ;
- vérifiée ;
- comparée.

Ce travail représente probablement la partie la moins spectaculaire de toute l'étude.

C'est pourtant lui qui rendra possible toutes les expérimentations suivantes.

---

# Jour 11 et suivants

Les semaines suivantes furent consacrées à :

- l'extraction des APK système ;
- l'analyse du firmware ;
- la reconstruction de `super.img` ;
- l'intégration d'un launcher alternatif ;
- la validation cryptographique des images ;
- la préparation d'un firmware expérimental.

Chaque étape sera détaillée dans les volumes suivants.

---

# Ce que cette chronologie nous apprend

En relisant cette succession d'événements, un élément apparaît clairement.

Aucune découverte majeure n'a été obtenue grâce au hasard.

Chaque résultat est la conséquence directe d'une méthode.

Observer.

Vérifier.

Documenter.

Puis seulement modifier.

Cette philosophie restera constante jusqu'à la dernière page de cet ouvrage.

---

## À retenir

> [!TIP]
> Si un seul enseignement devait être retenu de cette première phase, ce serait celui-ci :

> **Les sauvegardes et la compréhension du système doivent toujours précéder les optimisations.**

Une ROM modifiée peut toujours être reconstruite.

Une partition détruite sans sauvegarde est souvent perdue.

---

## Chapitre suivant

➡️ **08 – Difficultés initiales**

Le prochain chapitre ne décrira pas des réussites, mais les obstacles rencontrés pendant cette enquête : incompatibilités d'outils, absence de Fastboot exploitable, problèmes de montage d'images, collisions Git sous macOS, difficultés avec `lpmake`, limitations de `jadx`, différences entre Android et Recovery, et la manière dont chacune de ces difficultés a été résolue. Ces échecs sont essentiels, car ils ont façonné la méthodologie finale.