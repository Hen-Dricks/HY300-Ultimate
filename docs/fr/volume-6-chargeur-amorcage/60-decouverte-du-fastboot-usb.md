---
title: "Découverte du Fastboot USB"
volume: 6
chapter: 60
status: complete
last_updated: 2026-07-15
authors:
  - Projet HY300 Ultimate
---

# Chapitre 60 — Découverte du Fastboot USB

## Résumé

La découverte de l'accès **Fastboot via USB** constitue l'une des avancées techniques les plus importantes de ce projet.

Jusqu'à cette étape, toutes les investigations avaient été réalisées depuis Android grâce à Android Debug Bridge (ADB). Bien que cette méthode permette une analyse approfondie du système d'exploitation, elle reste dépendante du bon démarrage d'Android.

La mise en évidence d'une interface Fastboot accessible au moyen d'un simple câble **USB Type-A vers USB Type-A** a ouvert un nouvel espace d'investigation : celui du chargeur d'amorçage, de la table de partitions et du modèle de sécurité du système.

Cette découverte transforme le projet d'une analyse logicielle en une véritable plateforme d'ingénierie firmware.

---

# 60.1 Situation avant la découverte

Lors des premières phases du projet, plusieurs hypothèses étaient envisagées.

Le projecteur semblait uniquement proposer :

- Android Debug Bridge (ADB) ;
- les mises à jour OTA ;
- un environnement Android standard.

Aucune documentation publique ne faisait état d'une interface Fastboot.

Toutes les opérations dépendaient donc d'Android.

```
Ordinateur

↓

ADB TCP/IP

↓

Android

↓

Firmware
```

Cette dépendance limitait fortement les possibilités d'investigation.

---

# 60.2 Découverte de Fastboot

Après avoir remplacé le câble USB utilisé précédemment par un câble **USB Type-A vers USB Type-A**, le projecteur fut reconnecté directement à la station de développement.

La commande suivante fut exécutée.

```bash
fastboot devices
```

Le résultat fut immédiat.

```text
c3d9b8674f4b94f6    fastboot
```

Cette réponse démontre que le projecteur expose une interface Fastboot pleinement fonctionnelle via USB.

Contrairement aux hypothèses initiales, aucun outil propriétaire Rockchip n'était nécessaire pour établir la communication.

---

# 60.3 Validation de la communication

La première commande de validation fut :

```bash
fastboot getvar all
```

L'ensemble des informations retournées confirma immédiatement que la communication était opérationnelle.

Parmi les variables les plus importantes figuraient :

```text
product:rk3326_sgo

version-os:12

treble-enabled:true

dynamic-partition:true

secure:yes

unlocked:no
```

Ces informations proviennent directement du périphérique et constituent une source indépendante des analyses réalisées depuis Android.

---

# 60.4 Première cartographie du firmware

Fastboot a immédiatement permis d'obtenir :

- le nom de la plateforme ;
- la version du système ;
- l'état du chargeur d'amorçage ;
- l'état de sécurité ;
- la présence des partitions dynamiques ;
- la taille exacte des partitions.

Cette étape marque la première validation indépendante du travail de reconstruction réalisé précédemment à partir de `super.img`.

---

# 60.5 Découverte du mode Fastbootd

Parmi les variables retournées figurait :

```text
is-userspace:yes
```

Cette propriété indique que le périphérique exécute **Fastbootd**, également appelé **Userspace Fastboot**.

Il ne s'agit donc pas du Fastboot historique intégré directement au chargeur d'amorçage.

L'architecture est la suivante.

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

Cette organisation est cohérente avec Android 12 et l'utilisation des partitions dynamiques.

---

# 60.6 Validation des partitions

Fastboot a confirmé plusieurs éléments essentiels.

```
super

↓

system

vendor

product

odm

system_ext

vendor_dlkm

odm_dlkm
```

La présence de ces partitions logiques confirme l'architecture reconstruite lors des précédents volumes.

---

# 60.7 Validation de Treble

Fastboot rapporte :

```text
treble-enabled:true
```

Cette information confirme que le firmware suit l'architecture Android Treble.

Le découpage entre :

- framework Android ;
- composants fournisseurs (Vendor) ;
- composants ODM ;

correspond parfaitement aux observations réalisées lors de l'analyse de `super.img`.

---

# 60.8 Validation des partitions dynamiques

Une autre variable importante est :

```text
dynamic-partition:true
```

Elle confirme que :

- les partitions système sont regroupées dans `super.img` ;
- le firmware utilise **Dynamic Partitions** ;
- la reconstruction de la ROM devra obligatoirement passer par la reconstruction de `super.img`.

Cette validation était particulièrement importante avant le développement de la ROM personnalisée.

---

# 60.9 Découverte de l'état du chargeur d'amorçage

Fastboot indique également :

```text
secure:yes

unlocked:no
```

Ces deux propriétés montrent que :

- la chaîne de démarrage sécurisée est active ;
- le chargeur d'amorçage est verrouillé ;
- Android Verified Boot reste actif.

Le projet n'a réalisé aucune tentative de contournement de ces mécanismes.

Toutes les analyses ont été effectuées en lecture seule.

---

# 60.10 Commandes indisponibles

Certaines commandes Fastboot habituellement présentes sur les smartphones Android ne sont pas disponibles.

Par exemple :

```bash
fastboot flashing get_unlock_ability
```

renvoie :

```text
FAILED (remote: 'Unrecognized command flashing get_unlock_ability')
```

De même :

```bash
fastboot oem device-info
```

retourne :

```text
FAILED (remote: 'Unable to open fastboot HAL')
```

Ces réponses ne traduisent pas un dysfonctionnement.

Elles indiquent simplement que cette implémentation de Fastboot expose uniquement les fonctionnalités nécessaires au constructeur.

---

# 60.11 Transition vers le Recovery

Une autre commande importante fut testée.

```bash
fastboot reboot recovery
```

Le périphérique redémarra correctement dans le Recovery.

Une fois le démarrage terminé :

```bash
adb devices -l
```

renvoyait :

```text
c3d9b8674f4b94f6 recovery
```

La transition entre Fastboot et Recovery est donc entièrement fonctionnelle.

---

# 60.12 Apports pour le projet

Cette découverte apporte plusieurs bénéfices majeurs.

## Validation indépendante

Le firmware peut désormais être étudié sans dépendre exclusivement d'Android.

---

## Validation de la table de partitions

Les tailles réelles des partitions sont directement fournies par le système.

---

## Validation du modèle de sécurité

Fastboot fournit des informations essentielles concernant :

- Verified Boot ;
- l'état du chargeur d'amorçage ;
- les partitions logiques ;
- la configuration Treble.

---

## Fiabilité

La liaison USB s'est révélée beaucoup plus stable que la connexion réseau utilisée jusque-là.

---

# 60.13 Enseignements

La découverte de Fastboot marque une rupture importante dans le projet.

Le flux de travail devient désormais :

```
Android

↓

ADB

↓

Recovery

↓

Fastboot

↓

Analyse Firmware
```

Chaque environnement confirme les informations obtenues dans les autres.

Cette redondance améliore considérablement la fiabilité des conclusions.

---

# 60.14 Conclusion

La découverte de Fastboot via USB constitue un jalon majeur du projet HY300 Ultimate.

Grâce à un simple câble **USB Type-A vers USB Type-A**, le projecteur expose une interface permettant d'obtenir des informations de bas niveau sur son architecture, ses partitions et son modèle de sécurité.

Les données recueillies ont confirmé de manière indépendante les travaux de reverse engineering réalisés dans les volumes précédents et offrent désormais une base fiable pour la validation et le déploiement progressif de la ROM personnalisée.

Cette étape marque le passage de l'analyse du système Android à une compréhension complète de l'infrastructure firmware de l'appareil.