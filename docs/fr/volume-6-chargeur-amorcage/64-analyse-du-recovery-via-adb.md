---
title: "Analyse du Recovery via ADB"
volume: 6
chapter: 64
status: complete
last_updated: 2026-07-15
authors:
  - Projet HY300 Ultimate
---

# Chapitre 64 — Analyse du Recovery via ADB

## Résumé

Après la découverte de Fastboot USB, l'étape suivante consistait à analyser l'environnement **Recovery** du HY300 Ultimate.

Alors que Fastboot fournit principalement des informations relatives au chargeur d'amorçage et aux partitions, le Recovery constitue un environnement Android minimal permettant d'accéder à de nombreuses informations système indépendamment du système principal.

L'accès au Recovery via ADB a permis de confirmer plusieurs découvertes importantes concernant l'architecture du firmware, la configuration persistante du système, les partitions accessibles et les services réellement exécutés en mode maintenance.

Cette analyse constitue une troisième source d'information indépendante venant compléter les observations réalisées depuis Android et Fastboot.

---

# 64.1 Objectifs

Cette phase avait plusieurs objectifs.

- Vérifier si le Recovery expose Android Debug Bridge.
- Identifier les partitions accessibles.
- Examiner les systèmes de fichiers montés.
- Collecter les propriétés système persistantes.
- Identifier les services réellement actifs.
- Comparer l'environnement Recovery au système Android principal.

Toutes les opérations ont été réalisées exclusivement en lecture seule.

---

# 64.2 Accès au Recovery

Depuis Fastboot, le redémarrage vers le Recovery a été effectué avec la commande :

```bash
fastboot reboot recovery
```

Une fois le Recovery entièrement chargé, l'appareil apparaît immédiatement dans la liste des périphériques ADB.

```bash
adb devices -l
```

Retour :

```text
c3d9b8674f4b94f6    recovery
```

L'ancienne connexion réseau apparaît simultanément comme inactive.

```text
192.168.1.23:3268    offline
```

Cette observation confirme qu'il s'agit du même appareil utilisant simplement deux moyens de communication différents selon son état d'exécution.

---

# 64.3 Confirmation de l'environnement Recovery

L'analyse des propriétés système montre immédiatement que le périphérique exécute bien le Recovery Android.

Parmi les services observés :

```text
init.svc.recovery=running

init.svc.adbd=running
```

À l'inverse :

```text
init.svc.fastbootd=stopped
```

Cette information confirme que Fastbootd n'est plus actif et que le périphérique fonctionne bien dans son environnement Recovery standard.

---

# 64.4 Inventaire des partitions

Le Recovery expose directement les partitions présentes dans le stockage via :

```bash
adb shell ls /dev/block/by-name
```

Les principales partitions observées sont :

```text
boot
recovery
vbmeta
super
metadata
misc
dtbo
trust
uboot
logo
cust
backup
security
baseparameter
userdata
```

Cette liste est cohérente avec celle obtenue précédemment grâce à Fastboot.

---

# 64.5 Analyse des systèmes de fichiers

La commande :

```bash
adb shell mount
```

montre que le Recovery monte volontairement un nombre limité de partitions.

Contrairement au système Android, les partitions logiques suivantes ne sont pas montées automatiquement :

- system
- vendor
- product
- odm

En revanche, le Recovery monte principalement :

- metadata
- cust
- tmpfs
- proc
- sysfs
- devtmpfs

Cette stratégie réduit les risques de modification accidentelle du système.

---

# 64.6 Propriétés système accessibles

Malgré son environnement minimal, le Recovery expose un nombre important de propriétés Android.

Parmi les plus intéressantes :

```text
ro.build.version.release

ro.build.version.sdk

ro.build.fingerprint

ro.build.type

ro.product.*

persist.*
```

Ces informations permettent d'étudier le firmware même lorsque le système principal ne démarre plus.

---

# 64.7 Informations de compilation

Le Recovery confirme les informations précédemment observées.

Version Android :

```text
Android 12
```

Type de compilation :

```text
userdebug
```

Une observation particulièrement intéressante concerne la date de compilation.

```text
Thu Dec 4 2025
```

Alors que le niveau de correctif de sécurité reste :

```text
2022-07-05
```

Cette différence laisse penser que le constructeur a recompilé le firmware plusieurs années après la base Android utilisée, sans mettre à jour le niveau officiel des correctifs de sécurité.

---

# 64.8 Présence de daemon12138

Le Recovery confirme également la présence du composant OEM identifié dans les volumes précédents.

La propriété suivante reste visible :

```text
persist.daemon12138_switch=1
```

Cette observation est importante.

Elle montre que cette configuration est persistante et indépendante du système Android actuellement exécuté.

---

# 64.9 Configuration Keystone

Le Recovery expose également plusieurs propriétés liées au système de correction trapézoïdale.

Par exemple :

```text
persist.sys.keystone.*
```

Ces propriétés restent accessibles même lorsque le moteur graphique Android n'est pas lancé.

Cela confirme que la configuration Keystone est conservée dans des propriétés persistantes du système.

---

# 64.10 Configuration ADB TCP

L'une des découvertes les plus intéressantes concerne la propriété :

```text
service.adb.tcp.port=3268
```

Cette valeur explique définitivement pourquoi toutes les connexions ADB réseau utilisaient le port :

```
3268
```

Contrairement aux appareils Android classiques qui utilisent généralement le port 5555.

Le comportement observé depuis les premiers essais trouve ainsi son explication.

---

# 64.11 Comparaison des environnements

Les trois environnements étudiés présentent des caractéristiques complémentaires.

| Fonction             | Android   | Recovery | Fastboot |
| -------------------- | --------- | -------- | -------- |
| Applications         | Oui       | Non      | Non      |
| Framework Android    | Oui       | Minimal  | Non      |
| ADB                  | Oui       | Oui      | Non      |
| Fastboot             | Non       | Non      | Oui      |
| Informations système | Oui       | Oui      | Oui      |
| Table des partitions | Partielle | Oui      | Oui      |
| Services Android     | Oui       | Limités  | Non      |

Cette complémentarité constitue l'un des principaux atouts de la méthodologie employée.

---

# 64.12 Intérêt pour le développement

Le Recovery devient un outil particulièrement précieux pour le développement de la ROM personnalisée.

Il permet notamment :

- d'effectuer des diagnostics lorsque le système principal ne démarre plus ;
- de collecter les propriétés persistantes ;
- d'examiner les partitions ;
- de vérifier la configuration matérielle ;
- de préparer des opérations de maintenance.

Le Recovery constitue ainsi un environnement d'analyse indépendant particulièrement fiable.

---

# 64.13 Architecture globale

À ce stade du projet, trois niveaux d'analyse sont disponibles.

```text
               HY300 Ultimate

                     │

     ┌───────────────┼───────────────┐
     │               │               │

 Android         Recovery        Fastboot

     │               │               │

 Applications   Diagnostics    Bootloader

 Framework      Partitions     Sécurité

 Services       Propriétés     Firmware

 Runtime        Maintenance    Validation
```

Cette approche permet de confronter systématiquement les informations obtenues par plusieurs interfaces indépendantes.

---

# 64.14 Enseignements

L'étude du Recovery met en évidence plusieurs points importants.

- Le Recovery constitue un véritable environnement Android minimal.
- Les propriétés persistantes restent accessibles.
- Les partitions critiques sont visibles.
- Les services essentiels continuent de fonctionner.
- Les informations recueillies complètent celles obtenues via Android et Fastboot.

Cette redondance augmente considérablement la fiabilité des conclusions du projet.

---

# 64.15 Conclusion

L'analyse du Recovery confirme que le HY300 Ultimate dispose d'un environnement de maintenance complet, accessible via ADB USB.

Loin d'être un simple outil de restauration, le Recovery fournit une vue indépendante de l'architecture du firmware, des partitions, des propriétés persistantes et de la configuration système.

Combinées aux analyses réalisées depuis Android et Fastboot, ces observations offrent une compréhension particulièrement complète de la plateforme.

Le Recovery devient ainsi un élément essentiel de la méthodologie d'ingénierie retenue pour le développement, la validation et la maintenance de la future ROM personnalisée.