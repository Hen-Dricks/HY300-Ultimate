---
title: "Évolution du débogage USB"
volume: 6
chapter: 59
status: complete
last_updated: 2026-07-15
authors:
  - Projet HY300 Ultimate
---

# Chapitre 59 — Évolution du débogage USB

## Résumé

L'une des avancées les plus importantes du projet HY300 Ultimate fut la découverte d'un accès USB complet au projecteur.

Au début des recherches, toutes les interactions reposaient exclusivement sur Android Debug Bridge (ADB) via le réseau Wi-Fi. Cette méthode permettait d'étudier le système Android, mais imposait plusieurs contraintes : dépendance au réseau local, impossibilité d'accéder au chargeur d'amorçage et perte totale de communication en cas d'échec du démarrage d'Android.

La découverte qu'un simple câble **USB Type-A vers USB Type-A** permettait d'établir une communication directe avec le projecteur a profondément modifié l'approche du projet. Celui-ci est ainsi passé d'une simple analyse logicielle à une véritable plateforme d'ingénierie firmware.

---

# 59.1 Contexte initial

Les premières phases du projet ont été réalisées exclusivement à l'aide d'ADB via le réseau.

Le projecteur exposait un serveur ADB sur un port TCP non standard.

```
192.168.1.23:3268
```

Contrairement aux appareils Android classiques qui utilisent généralement le port **5555**, le HY300 Ultimate configure explicitement le port **3268**.

Cette configuration sera confirmée plus tard lors de l'analyse du Recovery grâce à la propriété :

```text
service.adb.tcp.port=3268
```

Le flux de travail initial pouvait être représenté ainsi :

```
Ordinateur

      │

Réseau Wi-Fi

      │

ADB TCP/IP

      │

HY300 Ultimate
```

Cette architecture fonctionnait correctement tant qu'Android était opérationnel.

---

# 59.2 Limitations du débogage réseau

L'utilisation exclusive d'ADB via TCP/IP présentait plusieurs inconvénients.

## Dépendance au réseau

Chaque session nécessitait :

- un réseau Wi-Fi fonctionnel ;
- une adresse IP valide ;
- Android entièrement démarré ;
- le service ADB actif.

En cas de problème de démarrage, toute communication devenait impossible.

---

## Instabilité

Au cours des différents essais, plusieurs situations ont été rencontrées :

- déconnexions ;
- changements d'adresse IP ;
- appareils signalés comme *offline* ;
- pertes de connexion ;
- latence réseau.

Ces phénomènes compliquaient les cycles de développement de la ROM.

---

## Absence d'accès au démarrage

ADB ne devient disponible qu'après le lancement du système Android.

Il est donc incapable d'interagir avec :

- le chargeur d'amorçage ;
- Fastboot ;
- les premières étapes du démarrage.

L'analyse restait limitée au système déjà chargé en mémoire.

---

# 59.3 Découverte de la communication USB

Plusieurs essais furent réalisés avec différents câbles USB.

Les premiers tests ne produisirent aucun résultat exploitable.

Finalement, un câble standard :

```
USB Type-A

      ↕

USB Type-A
```

fut utilisé entre le projecteur et la station de développement.

La commande suivante fut immédiatement reconnue :

```bash
fastboot devices
```

Le résultat obtenu fut :

```text
c3d9b8674f4b94f6    fastboot
```

Cette réponse confirmait sans ambiguïté que le projecteur expose une interface USB pleinement exploitable.

---

# 59.4 Conséquences immédiates

Cette découverte transforma complètement le flux de travail.

Avant :

```
Android

↓

ADB Wi-Fi

↓

Analyse
```

Après :

```
USB

├── ADB Android
├── ADB Recovery
└── Fastboot
```

Le développement du firmware ne dépendait plus du réseau local.

---

# 59.5 Accès au Recovery

La commande :

```bash
fastboot reboot recovery
```

permit d'accéder directement au Recovery.

Une fois le système redémarré, la commande :

```bash
adb devices -l
```

renvoya :

```text
c3d9b8674f4b94f6 recovery
```

L'ancienne connexion TCP apparaissait simultanément sous la forme :

```text
192.168.1.23:3268 offline
```

Cette observation démontre qu'il s'agit bien du même appareil, simplement accessible par différents moyens selon son état de fonctionnement.

---

# 59.6 Les trois environnements d'exécution

À l'issue de cette découverte, le projet disposait désormais de trois environnements indépendants.

```
Android

↓

ADB

────────────

Recovery

↓

ADB USB

────────────

Fastboot

↓

USB
```

Chacun expose un ensemble différent d'informations techniques.

| Environnement | Utilisation principale |
| ------------- | ---------------------- |
| Android       | Analyse du système     |
| Recovery      | Diagnostic             |
| Fastboot      | Analyse du firmware    |

Ces trois points d'accès permettent de valider les informations obtenues de manière indépendante.

---

# 59.7 Avantages de la communication USB

L'utilisation d'une liaison USB apporte plusieurs bénéfices majeurs.

## Fiabilité

La communication n'est plus dépendante :

- du Wi-Fi ;
- du routeur ;
- des changements d'adresse IP ;
- de la qualité du réseau.

---

## Rapidité

Les commandes s'exécutent presque instantanément, ce qui accélère considérablement les cycles de développement.

---

## Diagnostics avancés

L'accès USB permet désormais :

- le démarrage du Recovery ;
- l'accès à Fastboot ;
- la collecte d'informations sur le chargeur d'amorçage ;
- la validation de la table de partitions.

---

## Robustesse

Même lorsqu'Android refuse de démarrer, le Recovery reste accessible.

Cela réduit fortement le risque de perdre tout accès au projecteur lors du développement de la ROM.

---

# 59.8 Évolution de la méthodologie

L'évolution du projet peut être résumée ainsi.

```
Phase 1

ADB Wi-Fi

↓

Analyse Android

────────────

Phase 2

Extraction Firmware

↓

Reverse Engineering

────────────

Phase 3

USB

↓

ADB

↓

Recovery

↓

Fastboot

↓

Ingénierie Firmware
```

Cette progression marque le passage d'une simple observation du système vers une véritable maîtrise de son architecture.

---

# 59.9 Enseignements

Cette étape met en évidence plusieurs points importants.

- Le débogage réseau constitue une excellente solution d'exploration initiale.
- La communication USB est nettement plus fiable pour le développement.
- Le Recovery représente une plateforme de diagnostic très précieuse.
- Fastboot apporte une validation indépendante de l'architecture du firmware.
- La multiplication des points d'accès améliore considérablement la qualité des analyses.

---

# 59.10 Conclusion

La découverte de la communication USB constitue l'un des tournants majeurs du projet HY300 Ultimate.

Grâce à un simple câble **USB Type-A vers USB Type-A**, le projecteur expose désormais trois environnements complémentaires : Android, Recovery et Fastboot.

Cette évolution a permis de s'affranchir des limitations du débogage réseau, d'améliorer la fiabilité des investigations et d'établir une base solide pour la suite du développement de la ROM personnalisée.

Le projet entre ainsi dans une nouvelle phase : celle de l'ingénierie firmware, où chaque composant du système peut être étudié, documenté et validé à partir de plusieurs sources indépendantes.