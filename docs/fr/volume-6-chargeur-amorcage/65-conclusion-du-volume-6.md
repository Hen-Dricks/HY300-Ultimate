---
title: "Conclusion du Volume 6"
volume: 6
chapter: 65
status: complete
last_updated: 2026-07-15
authors:
  - Projet HY300 Ultimate
---

# Chapitre 65 — Conclusion du Volume 6

## Résumé

Le sixième volume marque une étape déterminante dans le projet **HY300 Ultimate**.

Jusqu'à présent, l'ensemble des analyses reposait essentiellement sur Android Debug Bridge (ADB), l'extraction du firmware et le reverse engineering des partitions système. La découverte d'une communication USB pleinement fonctionnelle a profondément modifié cette approche.

L'accès successif à **ADB**, **Recovery** puis **Fastboot** a permis de disposer de trois environnements indépendants offrant chacun une vision complémentaire du système.

Cette convergence constitue l'une des principales forces de ce travail : les informations ne reposent plus sur une seule méthode d'analyse mais sur plusieurs sources indépendantes qui se confirment mutuellement.

---

# 65.1 Objectifs du volume

Ce volume poursuivait plusieurs objectifs.

- Déterminer si le projecteur exposait une interface USB exploitable.
- Vérifier la présence de Fastboot.
- Identifier le type de Fastboot utilisé.
- Étudier le modèle de sécurité.
- Valider la table des partitions.
- Examiner le Recovery Android.
- Évaluer les conséquences pour le développement de la ROM personnalisée.

L'ensemble de ces objectifs a été atteint.

---

# 65.2 Une évolution majeure du projet

Le projet a connu trois grandes phases.

## Phase 1 — Exploration Android

```
ADB Wi-Fi

↓

Android

↓

Analyse du système
```

Cette première étape a permis de comprendre :

- les applications OEM ;
- les services système ;
- les propriétés Android ;
- l'organisation générale du firmware.

Cependant, toute l'analyse dépendait du bon fonctionnement d'Android.

---

## Phase 2 — Reverse engineering du firmware

```
Firmware

↓

Extraction

↓

super.img

↓

Reverse Engineering
```

Cette phase a permis :

- d'étudier les partitions dynamiques ;
- de reconstruire la structure de `super.img` ;
- d'identifier les composants OEM ;
- de préparer la future ROM personnalisée.

---

## Phase 3 — Ingénierie bas niveau

La découverte du câble USB Type-A vers USB Type-A a ouvert une nouvelle étape.

```
USB

↓

ADB

↓

Recovery

↓

Fastboot
```

Le projet ne dépend plus uniquement d'Android.

Il devient désormais possible d'étudier la plateforme depuis plusieurs niveaux d'exécution.

---

# 65.3 Les principales découvertes

Les recherches menées dans ce volume ont permis de confirmer plusieurs éléments majeurs.

## Communication USB

Le projecteur expose :

- Android Debug Bridge ;
- Recovery ADB ;
- Fastboot.

Cette découverte supprime la dépendance au réseau Wi-Fi pour le développement.

---

## Fastboot

Fastboot fournit notamment :

- l'identification matérielle ;
- les tailles officielles des partitions ;
- les partitions logiques ;
- la configuration Treble ;
- l'état du chargeur d'amorçage ;
- les paramètres de sécurité.

Ces informations proviennent directement du firmware.

---

## Fastbootd

Le périphérique indique :

```text
is-userspace:yes
```

Cette propriété confirme l'utilisation de **Fastbootd**.

L'architecture est conforme aux spécifications modernes d'Android 12 utilisant les partitions dynamiques.

---

## Recovery

Le Recovery expose :

- Android Debug Bridge ;
- les propriétés persistantes ;
- la table des partitions ;
- les services essentiels ;
- la configuration OEM.

Il constitue un environnement d'analyse indépendant particulièrement utile.

---

# 65.4 Validation des volumes précédents

L'un des principaux résultats de ce volume est la validation indépendante des conclusions obtenues jusqu'à présent.

Les analyses réalisées depuis Android, Recovery et Fastboot convergent toutes vers les mêmes observations.

Parmi les éléments désormais confirmés figurent :

- Android 12 ;
- la plateforme RK3326 ;
- Treble ;
- les partitions dynamiques ;
- `super.img` ;
- les partitions logiques ;
- le modèle sans A/B ;
- Android Verified Boot ;
- un chargeur d'amorçage verrouillé.

Cette cohérence renforce fortement la crédibilité des travaux réalisés.

---

# 65.5 Le modèle de sécurité

Les investigations montrent que le constructeur a conservé un modèle de sécurité relativement moderne.

Les principales protections observées sont :

- Secure Boot ;
- Android Verified Boot ;
- Fastbootd ;
- chargeur d'amorçage verrouillé ;
- partitions dynamiques.

Le projet n'a réalisé aucune tentative de contournement de ces mécanismes.

Toutes les analyses ont été effectuées dans une logique de compréhension et de documentation.

---

# 65.6 Une nouvelle méthodologie

À l'issue de ce volume, le projet adopte désormais une méthodologie reposant sur trois environnements complémentaires.

```
                 HY300 Ultimate

                       │

      ┌────────────────┼────────────────┐

      │                │                │

   Android         Recovery        Fastboot

      │                │                │

   Runtime        Maintenance      Firmware

   Services       Diagnostics      Sécurité

 Applications     Partitions       Validation
```

Cette organisation présente plusieurs avantages.

- Chaque environnement valide les observations des autres.
- Les erreurs d'interprétation sont réduites.
- Les analyses deviennent reproductibles.
- Les diagnostics restent possibles même lorsqu'Android ne démarre plus.

---

# 65.7 Conséquences pour la ROM personnalisée

Les découvertes réalisées dans ce volume constituent une base solide pour poursuivre le développement de la ROM.

Les éléments suivants sont désormais connus avec certitude :

- la structure exacte des partitions ;
- la taille maximale de `super.img` ;
- les partitions logiques ;
- le fonctionnement de Fastbootd ;
- l'accessibilité du Recovery ;
- l'état du modèle de sécurité.

Ces informations permettront de valider chaque image reconstruite avant son déploiement.

---

# 65.8 Évolution du projet

Le projet HY300 Ultimate ne se limite plus à une simple modification de firmware.

Il comprend désormais :

- une documentation technique complète ;
- des scripts de collecte automatisés ;
- des outils de reverse engineering ;
- des rapports reproductibles ;
- des procédures de validation ;
- une architecture documentaire organisée.

Le projet évolue progressivement vers une véritable plateforme d'ingénierie firmware.

---

# 65.9 Travaux restant à réaliser

Malgré les avancées importantes de ce volume, plusieurs étapes restent à mener.

Les prochaines priorités sont notamment :

- l'audit complet de la ROM V0.1 ;
- la validation des images reconstruites ;
- le premier flash de validation ;
- les mesures de performances de référence ;
- l'optimisation mémoire ;
- l'analyse graphique ;
- l'intégration de Projectivy ;
- la désactivation progressive des composants OEM inutiles.

Ces travaux constitueront le cœur des prochains volumes.

---

# 65.10 Enseignements

Ce volume met en évidence plusieurs enseignements importants.

- Les analyses doivent toujours être validées par plusieurs sources indépendantes.
- La communication USB est beaucoup plus fiable que le débogage réseau.
- Le Recovery est un excellent environnement de diagnostic.
- Fastboot constitue une source fiable pour la validation de la table des partitions.
- Les partitions dynamiques imposent une approche centrée sur `super.img`.
- Une documentation rigoureuse est aussi importante que les modifications techniques elles-mêmes.

Ces principes guideront l'ensemble des développements futurs.

---

# 65.11 Transition vers la phase suivante

Avec la fin de ce sixième volume, la phase d'exploration de la plateforme peut être considérée comme largement achevée.

Les prochaines recherches ne porteront plus principalement sur la compréhension du matériel mais sur son amélioration.

Le projet entre désormais dans une nouvelle étape :

1. auditer la ROM personnalisée V0.1 ;
2. comparer son contenu au firmware d'origine ;
3. mesurer les performances avant et après modification ;
4. optimiser progressivement le système ;
5. produire une ROM stable et documentée ;
6. préparer une publication complète du projet sur GitHub.

Le travail évolue donc naturellement du **reverse engineering** vers **l'ingénierie firmware**.

---

# 65.12 Conclusion générale du Volume 6

Ce volume marque la fin d'une étape essentielle du projet HY300 Ultimate.

Grâce à la découverte d'une communication USB complète, le projecteur peut désormais être étudié depuis trois environnements distincts : Android, Recovery et Fastboot.

Les informations obtenues au travers de ces différentes interfaces convergent vers une description cohérente de la plateforme et confirment la validité des analyses réalisées dans les volumes précédents.

Le projet dispose désormais d'une compréhension approfondie de l'architecture matérielle et logicielle de l'appareil, de son organisation interne, de son modèle de sécurité et de son processus de démarrage.

Cette base documentaire robuste permet d'aborder la prochaine phase avec confiance : **la validation, l'optimisation et l'évolution progressive de la ROM personnalisée**, dans une démarche rigoureuse, reproductible et respectueuse de l'intégrité du système d'origine.