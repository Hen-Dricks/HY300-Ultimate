---
title: "OTA, signatures et certificats"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 50 — OTA, signatures et certificats

> *« La sécurité d'une mise à jour ne dépend pas uniquement de son contenu. Elle dépend surtout de la confiance que le système accorde à son origine. »*

---

# Résumé exécutif

Les mises à jour OTA (Over-The-Air) constituent l'un des composants les plus sensibles d'un firmware Android.

Une mise à jour peut :

- corriger des bugs ;
- ajouter des fonctionnalités ;
- modifier profondément le système.

Mais elle peut également représenter un risque si son authenticité n'est pas correctement vérifiée.

Ce chapitre étudie les mécanismes de confiance observés sur le firmware HY300.

---

# Objectifs

Notre analyse cherche à répondre aux questions suivantes.

- Comment le firmware recherche-t-il les mises à jour ?
- Quels composants participent au processus OTA ?
- Les mises à jour semblent-elles authentifiées ?
- Quels certificats sont utilisés ?
- Quel est le rôle de `vbmeta` dans cette chaîne de confiance ?

---

# Architecture d'une mise à jour Android

Le processus peut être représenté ainsi.

```text
Serveur constructeur

↓

Téléchargement OTA

↓

Vérification

↓

Validation cryptographique

↓

Recovery

↓

Installation

↓

Redémarrage

↓

Android
```

Chaque étape contribue à protéger le système contre des mises à jour non autorisées.

---

# Les composants étudiés

Au cours de cette étude, plusieurs composants liés aux mises à jour ont été identifiés.

Parmi eux :

- application OTA constructeur (TXCZ OTA) ;
- scripts de mise à jour ;
- partition `recovery` ;
- partition `vbmeta`.

Le rôle exact de chacun est documenté dans les chapitres précédents.

---

# TXCZ OTA

Le firmware comporte une application dédiée aux mises à jour.

Son analyse porte notamment sur :

- les permissions ;
- les composants Android ;
- les services ;
- les communications réseau.

À ce stade, la présence de cette application ne permet pas de conclure à un comportement particulier.

Elle constitue simplement le point d'entrée du mécanisme OTA.

---

# Les certificats Android

Android utilise plusieurs certificats.

Ils servent notamment à :

- signer les applications système ;
- vérifier les packages OTA ;
- établir une chaîne de confiance.

Une application système correctement signée peut bénéficier de privilèges supplémentaires.

---

# Vérification des APK

Les APK système peuvent être inspectées afin d'identifier :

- leur certificat ;
- leur empreinte ;
- leur date de signature ;
- leur émetteur.

Exemple d'outils :

```bash
apksigner verify

keytool

apksigner verify --print-certs
```

Ces informations permettent de comparer les applications entre différentes versions du firmware.

---

# Android Verified Boot

Les mises à jour modernes s'appuient généralement sur Android Verified Boot (AVB).

Le rôle de `vbmeta` est notamment de garantir que les partitions critiques correspondent à ce qui est attendu.

Notre analyse vise à déterminer :

- si AVB est activé ;
- quelles partitions sont concernées ;
- comment la vérification est effectuée.

Les résultats seront complétés au fil des expérimentations.

---

# Chaîne de confiance

Le modèle de confiance peut être représenté ainsi.

```text
Clé privée constructeur

↓

Signature

↓

Package OTA

↓

Vérification

↓

Recovery

↓

Installation

↓

Boot

↓

AVB

↓

Android
```

Chaque maillon doit rester cohérent pour préserver l'intégrité du système.

---

# Analyse réseau

Une partie de l'audit consiste à observer :

- les requêtes vers les serveurs OTA ;
- les domaines contactés ;
- les éventuelles vérifications préalables.

Ces observations sont documentées séparément afin de distinguer les faits des hypothèses.

---

# Éléments observés

À ce stade du projet :

## Confirmé

- présence d'une application OTA propriétaire ;
- présence d'une partition `recovery` ;
- présence d'une partition `vbmeta`.

## À confirmer

- méthode exacte de validation cryptographique ;
- format des packages OTA ;
- certificats utilisés ;
- politique de mise à jour.

---

# Analyse de sécurité

Une mise à jour OTA n'est pas vulnérable par principe.

L'analyse portera notamment sur :

- la validation des signatures ;
- l'authenticité des packages ;
- les privilèges accordés au composant OTA.

Une faiblesse ne sera qualifiée de vulnérabilité qu'après démonstration expérimentale.

---

# Recommandations

Pour toute modification du firmware :

- conserver les partitions d'origine ;
- documenter les signatures observées ;
- vérifier les certificats des APK système ;
- ne jamais remplacer une partition sans comprendre son rôle dans la chaîne de confiance.

---

# Journal d'audit

**Objectif**

Étudier les mécanismes de mise à jour du firmware.

**Méthodologie**

Analyse statique des APK, des partitions et des composants liés à OTA.

**Résultat**

L'architecture générale du mécanisme de mise à jour est identifiée.

L'analyse détaillée des signatures et certificats se poursuit.

---

# Enseignements

Les mécanismes OTA ne doivent pas être considérés uniquement comme un moyen de distribuer des mises à jour.

Ils représentent également un élément essentiel de la sécurité du firmware.

La compréhension de cette chaîne de confiance est indispensable avant toute personnalisation d'un système Android moderne.

---

# Conclusion

Le firmware HY300 s'appuie sur plusieurs composants participant au processus de mise à jour.

Leur présence est cohérente avec l'architecture d'un appareil Android embarqué.

Les prochaines étapes consisteront à caractériser plus précisément les certificats utilisés, les méthodes de validation des packages et les interactions entre le mécanisme OTA et Android Verified Boot.

---

## Tableau récapitulatif

| Élément         |   Observé   |    Analysé    | Statut       |
| --------------- | :---------: | :-----------: | ------------ |
| TXCZ OTA        |      ✓      |       ✓       | Inventorié   |
| Recovery        |      ✓      | Partiellement | En cours     |
| vbmeta          |      ✓      | Partiellement | En cours     |
| Certificats APK |      ✓      |   En cours    | À compléter  |
| Validation OTA  | À confirmer |      Non      | À documenter |

---

> [!IMPORTANT]
> La présence d'un composant OTA, d'un certificat ou d'un mécanisme de signature ne constitue ni une garantie absolue de sécurité, ni une preuve de faiblesse. Les conclusions de ce projet reposent exclusivement sur des observations reproductibles et des analyses documentées.

---

# Chapitre suivant

➡️ **51 – microSD et intégrité : stockage externe, sauvegardes et validation des données**