---
title: "Analyse du Fastboot en espace utilisateur (Fastbootd)"
volume: 6
chapter: 61
status: complete
last_updated: 2026-07-15
authors:
  - Projet HY300 Ultimate
---

# Chapitre 61 — Analyse du Fastboot en espace utilisateur (Fastbootd)

## Résumé

L'une des découvertes les plus importantes réalisées au cours de l'analyse USB est que le HY300 Ultimate n'utilise pas le **Fastboot classique intégré au chargeur d'amorçage**, mais une implémentation moderne appelée **Fastboot en espace utilisateur**, plus communément désignée sous le nom de **Fastbootd**.

Cette distinction est essentielle. Elle explique pourquoi certaines commandes Fastboot fonctionnent parfaitement tandis que d'autres, pourtant documentées sur de nombreux appareils Android, ne sont pas disponibles.

L'identification de Fastbootd permet également de mieux comprendre l'architecture Android 12 adoptée par le constructeur ainsi que les contraintes qui s'appliqueront au développement de la ROM personnalisée.

---

# 61.1 Contexte

Pendant de nombreuses années, Fastboot était directement intégré au chargeur d'amorçage.

Son rôle consistait à communiquer avec un ordinateur avant le démarrage d'Android afin de :

- lire les informations du périphérique ;
- écrire des partitions ;
- démarrer un noyau temporaire ;
- déverrouiller le chargeur d'amorçage ;
- effectuer certaines opérations de maintenance.

L'architecture pouvait être représentée ainsi.

```
Ordinateur

↓

USB

↓

Fastboot

↓

Chargeur d'amorçage

↓

Mémoire Flash
```

Avec l'arrivée des **Dynamic Partitions**, Google a progressivement introduit **Fastbootd**.

---

# 61.2 Qu'est-ce que Fastbootd ?

Contrairement au Fastboot historique, **Fastbootd ne s'exécute pas dans le chargeur d'amorçage**.

Il est lancé depuis le Recovery Android.

L'architecture devient alors :

```
Chargeur d'amorçage

↓

Recovery

↓

Fastbootd

↓

USB

↓

Ordinateur
```

Dans ce modèle, Android est capable de gérer directement les partitions logiques contenues dans **super.img**.

Cette approche simplifie la manipulation des partitions dynamiques tout en conservant les mécanismes de sécurité d'Android.

---

# 61.3 Mise en évidence

Afin d'identifier précisément l'environnement Fastboot utilisé par le projecteur, la commande suivante fut exécutée.

```bash
fastboot getvar all
```

Parmi les nombreuses variables retournées figurait :

```text
is-userspace:yes
```

Cette propriété constitue une preuve directe.

Elle confirme que le périphérique fonctionne en **Fastbootd**.

Il ne s'agit donc pas d'une simple déduction fondée sur le comportement observé, mais bien d'une information explicitement fournie par le système.

---

# 61.4 Cohérence avec Android 12

Les variables suivantes furent également rapportées.

```text
dynamic-partition:true

treble-enabled:true

super-partition-name:super
```

Ces trois propriétés sont parfaitement cohérentes avec l'utilisation de Fastbootd.

Android 12 s'appuie sur :

- Treble ;
- les partitions dynamiques ;
- la partition `super`.

Fastbootd a précisément été conçu pour gérer cette architecture.

---

# 61.5 Validation de l'architecture des partitions

Fastboot confirme que les partitions suivantes sont **logiques**.

```text
system

vendor

product

odm

system_ext

vendor_dlkm

odm_dlkm
```

Ces partitions résident toutes dans :

```
super.img
```

Le fonctionnement observé correspond exactement à celui documenté par Android Open Source Project (AOSP).

---

# 61.6 Modèle de sécurité

Parmi les propriétés exposées figurent également :

```text
secure:yes

unlocked:no
```

Ces deux informations indiquent que :

- la chaîne de démarrage sécurisée est active ;
- le chargeur d'amorçage reste verrouillé ;
- Android Verified Boot est conservé.

Fastbootd n'affaiblit donc en rien le modèle de sécurité du système.

Il ne constitue pas un moyen de contourner les protections du constructeur.

---

# 61.7 Commandes disponibles

Au cours des essais, plusieurs commandes Fastboot furent exécutées avec succès.

| Commande                   | Résultat        |
| -------------------------- | --------------- |
| `fastboot devices`         | ✔ Fonctionnelle |
| `fastboot getvar all`      | ✔ Fonctionnelle |
| `fastboot reboot recovery` | ✔ Fonctionnelle |
| `fastboot reboot fastboot` | ✔ Fonctionnelle |

Ces commandes permettent :

- d'identifier le périphérique ;
- d'obtenir la configuration du firmware ;
- de naviguer entre Recovery et Fastboot.

---

# 61.8 Commandes indisponibles

Certaines commandes habituellement rencontrées sur les smartphones Android ont cependant échoué.

Exemple :

```bash
fastboot flashing get_unlock_ability
```

Résultat :

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

Ces erreurs ne traduisent pas une mauvaise communication.

Elles indiquent simplement que cette implémentation de Fastboot ne prend pas en charge ces fonctionnalités.

---

# 61.9 Le rôle du Fastboot HAL

Les messages d'erreur mentionnent :

```text
Fastboot HAL
```

Le **Fastboot HAL** (Hardware Abstraction Layer) est une couche logicielle facultative permettant d'ajouter :

- des commandes OEM ;
- des informations constructeur ;
- des fonctions de déverrouillage ;
- des opérations spécifiques au fabricant.

Le firmware du HY300 Ultimate expose une implémentation volontairement limitée de cette interface.

Cette limitation est fréquente sur les appareils Android embarqués.

---

# 61.10 Intégration avec le Recovery

Une observation intéressante concerne la transition entre Fastboot et Recovery.

Le flux observé est le suivant.

```
Android

↓

ADB

↓

Fastboot

↓

Recovery

↓

ADB Recovery
```

Le Recovery et Fastbootd apparaissent donc comme deux environnements étroitement liés.

Ils partagent une partie importante de leur infrastructure.

---

# 61.11 Conséquences pour le développement de la ROM

L'identification de Fastbootd influence directement la stratégie de développement.

Elle confirme notamment que :

- les partitions logiques devront être reconstruites via `super.img` ;
- les tailles des partitions pourront être validées directement par Fastboot ;
- les modifications devront respecter l'organisation des Dynamic Partitions.

Cette découverte réduit fortement les incertitudes liées à la reconstruction de la ROM.

---

# 61.12 Limites observées

Fastbootd reste plus limité qu'un Fastboot traditionnel.

Les restrictions identifiées sont :

- chargeur d'amorçage verrouillé ;
- absence de certaines commandes OEM ;
- impossibilité d'interroger les capacités de déverrouillage ;
- Fastboot HAL incomplet.

Ces limitations ne remettent toutefois pas en cause la possibilité de documenter précisément le firmware.

---

# 61.13 Enseignements

Le passage d'une analyse exclusivement réalisée depuis Android à une validation indépendante par Fastbootd constitue une évolution majeure.

Il permet désormais de confronter les observations issues de plusieurs environnements :

- Android ;
- Recovery ;
- Fastboot.

Cette redondance améliore considérablement la fiabilité des conclusions obtenues.

---

# 61.14 Conclusion

L'analyse du HY300 Ultimate montre que le constructeur a adopté **Fastbootd**, l'implémentation moderne du protocole Fastboot introduite avec les partitions dynamiques d'Android.

Cette architecture est parfaitement cohérente avec Android 12, Treble et `super.img`.

Bien que certaines fonctionnalités avancées de Fastboot ne soient pas disponibles, Fastbootd fournit toutes les informations nécessaires à la validation du firmware, de la table de partitions et du modèle de sécurité.

Cette découverte constitue une étape essentielle dans la préparation de la ROM personnalisée, en offrant une vision fiable et indépendante de l'architecture interne du système.