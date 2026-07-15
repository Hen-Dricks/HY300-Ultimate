---
title: "Modèle de sécurité Fastboot"
volume: 6
chapter: 63
status: complete
last_updated: 2026-07-15
authors:
  - Projet HY300 Ultimate
---

# Chapitre 63 — Modèle de sécurité Fastboot

## Résumé

L'accès à Fastboot a permis d'étudier pour la première fois le modèle de sécurité réellement implémenté par le HY300 Ultimate.

Contrairement à une simple analyse réalisée depuis Android, Fastboot expose directement plusieurs informations critiques concernant le démarrage sécurisé, l'état du chargeur d'amorçage, les partitions dynamiques et l'organisation générale du firmware.

Les données collectées montrent que le constructeur a adopté une architecture moderne héritée d'Android 12, tout en limitant volontairement certaines fonctionnalités de Fastboot afin de réduire les possibilités de modification du système.

L'objectif de ce chapitre est d'analyser ces mécanismes, d'en comprendre les implications et de définir les contraintes qui devront être respectées lors du développement de la ROM personnalisée.

---

# 63.1 Objectifs de l'analyse

L'étude du modèle de sécurité devait répondre aux questions suivantes.

- Le chargeur d'amorçage est-il verrouillé ?
- Android Verified Boot est-il actif ?
- Les partitions dynamiques sont-elles protégées ?
- Le périphérique utilise-t-il Fastboot ou Fastbootd ?
- Les mises à jour A/B sont-elles prises en charge ?
- Existe-t-il des commandes OEM permettant de modifier le comportement du système ?

Toutes ces questions conditionnent directement la stratégie de développement de la ROM.

---

# 63.2 Variables de sécurité exposées

La commande suivante a été utilisée :

```bash
fastboot getvar all
```

Parmi les variables retournées figurent :

```text
secure:yes

unlocked:no

dynamic-partition:true

treble-enabled:true

is-userspace:yes

slot-count:0
```

Ces informations décrivent les principaux mécanismes de sécurité du firmware.

---

# 63.3 Chargeur d'amorçage

Fastboot indique :

```text
unlocked:no
```

Cette propriété confirme que le chargeur d'amorçage est actuellement verrouillé.

Au cours de cette recherche :

- aucun déverrouillage n'a été tenté ;
- aucun composant de démarrage n'a été modifié ;
- aucune protection n'a été contournée.

Toutes les investigations ont été réalisées en conservant le comportement d'origine du constructeur.

---

# 63.4 Démarrage sécurisé

Une autre variable importante est :

```text
secure:yes
```

Cette propriété indique que la chaîne de démarrage sécurisée est active.

Même si le constructeur ne documente pas précisément son implémentation, cette information signifie généralement que plusieurs composants critiques sont vérifiés avant leur exécution.

Parmi eux figurent notamment :

- boot
- recovery
- vbmeta
- trust
- kernel

Ces partitions participent directement au processus de démarrage.

---

# 63.5 Android Verified Boot

L'inventaire des partitions révèle la présence de :

```text
vbmeta
```

Cette partition est utilisée par Android Verified Boot (AVB).

Son rôle consiste à garantir l'intégrité des partitions vérifiées avant le lancement du système.

Le fonctionnement simplifié est le suivant.

```
Bootloader

↓

vbmeta

↓

boot

↓

system

↓

Android
```

Toute modification des partitions protégées peut nécessiter une mise à jour cohérente des métadonnées de vérification.

---

# 63.6 Architecture des partitions dynamiques

Fastboot confirme également :

```text
dynamic-partition:true
```

Ainsi que :

```text
super-partition-name:super
```

Cela signifie que les partitions système sont regroupées dans un conteneur unique :

```
super
│
├── system
├── vendor
├── product
├── odm
├── system_ext
├── vendor_dlkm
└── odm_dlkm
```

La sécurité ne s'applique donc plus uniquement à une partition individuelle mais à l'organisation globale du conteneur.

---

# 63.7 Fastbootd

Une information particulièrement importante est :

```text
is-userspace:yes
```

Cette propriété confirme que le périphérique utilise **Fastbootd**.

Fastbootd est exécuté depuis le Recovery Android.

Il permet :

- la gestion des partitions dynamiques ;
- l'accès aux informations système ;
- certaines opérations de maintenance.

En revanche, il ne fournit pas nécessairement toutes les fonctionnalités d'un Fastboot intégré directement au chargeur d'amorçage.

---

# 63.8 Absence de mises à jour A/B

Fastboot indique :

```text
slot-count:0
```

De même :

```text
has-slot:boot:no

has-slot:system:no

has-slot:vendor:no
```

Le HY300 Ultimate ne met donc pas en œuvre le mécanisme Android des mises à jour transparentes (A/B).

Il repose sur une architecture à emplacement unique.

```
boot

↓

system

↓

userdata
```

Cette caractéristique simplifie la reconstruction de la ROM mais impose davantage de précautions lors du remplacement des partitions système.

---

# 63.9 Commandes Fastboot limitées

Plusieurs commandes classiques ont été testées.

```bash
fastboot flashing get_unlock_ability
```

Retour :

```text
FAILED (remote: 'Unrecognized command flashing get_unlock_ability')
```

Autre exemple :

```bash
fastboot oem device-info
```

Retour :

```text
FAILED (remote: 'Unable to open fastboot HAL')
```

Ces résultats montrent que le constructeur n'expose qu'un sous-ensemble des fonctionnalités Fastboot.

Il s'agit d'une limitation volontaire et non d'un dysfonctionnement.

---

# 63.10 Évaluation globale

Les principales protections observées peuvent être résumées dans le tableau suivant.

| Mécanisme                      | État | Validation |
| ------------------------------ | ---- | ---------- |
| Chargeur d'amorçage verrouillé | Oui  | ✔          |
| Secure Boot                    | Oui  | ✔          |
| Android Verified Boot          | Oui  | ✔          |
| Treble                         | Oui  | ✔          |
| Partitions dynamiques          | Oui  | ✔          |
| Fastbootd                      | Oui  | ✔          |
| Mises à jour A/B               | Non  | ✔          |

Cette architecture est conforme aux recommandations actuelles de Google pour Android 12.

---

# 63.11 Conséquences pour la ROM personnalisée

Ces observations définissent les règles qui devront être respectées.

## Les partitions critiques ne doivent pas être modifiées sans validation.

Cela concerne notamment :

- boot
- vbmeta
- trust
- uboot
- dtbo
- recovery

Une erreur sur l'un de ces composants peut empêcher complètement le démarrage.

---

## Les modifications devront privilégier super.img

Les futures évolutions porteront principalement sur :

- system
- vendor
- product
- odm

Toutes ces partitions étant regroupées dans `super.img`, leur reconstruction devra rester conforme aux tailles validées précédemment.

---

## Validation systématique

Avant chaque flash, il conviendra de vérifier :

- la taille des images ;
- les métadonnées LP ;
- les partitions logiques ;
- les sommes de contrôle ;
- la cohérence avec la cartographie officielle.

Cette approche permettra de limiter les risques d'erreur.

---

# 63.12 Philosophie du projet

L'objectif de cette recherche n'est pas de contourner les mécanismes de sécurité du constructeur.

Au contraire, la démarche consiste à :

- comprendre leur fonctionnement ;
- documenter leur architecture ;
- développer des outils reproductibles ;
- améliorer le système tout en respectant ses contraintes techniques.

La sécurité est donc considérée comme une composante de la plateforme et non comme un obstacle.

---

# 63.13 Enseignements

L'analyse de Fastboot met en évidence une plateforme moderne reposant sur plusieurs mécanismes complémentaires.

Le HY300 Ultimate combine :

- Android Verified Boot ;
- Fastbootd ;
- Treble ;
- les partitions dynamiques ;
- une chaîne de démarrage sécurisée ;
- un chargeur d'amorçage verrouillé.

L'ensemble forme une architecture cohérente, comparable à celle de nombreux appareils Android récents.

---

# 63.14 Conclusion

L'étude du modèle de sécurité confirme que le HY300 Ultimate repose sur une implémentation relativement moderne de l'architecture Android.

Les protections observées n'empêchent pas la compréhension du firmware, mais elles imposent un cadre strict pour toute modification future.

Les informations obtenues grâce à Fastboot constituent désormais une référence essentielle pour le développement de la ROM personnalisée. Elles permettent d'aborder les étapes suivantes avec une vision claire des contraintes techniques et des composants sensibles à préserver.

Cette analyse clôt la phase de caractérisation du modèle de sécurité et prépare le terrain pour les travaux d'optimisation et de reconstruction du firmware qui seront entrepris dans les volumes suivants.