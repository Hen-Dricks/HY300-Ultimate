---
title: "Découverte du réseau et identification d'ADB"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Draft"
language: "fr"
last_updated: "2026-07-14"
---

# Chapitre 4 — Découverte du réseau

> *« Lorsqu'un appareil refuse de répondre, la première étape n'est pas de l'attaquer. C'est de l'écouter. »*

---

# Introduction

À ce stade de notre enquête, nous connaissions déjà plusieurs éléments essentiels.

Nous avions identifié le SoC utilisé par le projecteur.

Nous savions qu'il exécutait Android 12.

Nous avions également constaté la présence d'un nombre important de composants propriétaires.

En revanche, nous ne disposions toujours d'aucun accès privilégié au système.

Modifier directement les partitions sans comprendre le fonctionnement interne du firmware aurait constitué une erreur.

Nous avons donc décidé de commencer par la méthode la plus prudente qui soit.

Observer le réseau.

---

# Pourquoi commencer par le réseau ?

Android est un système d'exploitation pensé pour communiquer.

Même lorsqu'aucun service utilisateur n'est exposé, plusieurs composants internes peuvent ouvrir des ports réseau.

Parmi eux :

- ADB (Android Debug Bridge)
- services de diagnostic constructeur
- OTA
- protocoles propriétaires
- serveurs HTTP embarqués
- services DLNA
- protocoles de découverte réseau

Dans certains cas, ces services sont uniquement accessibles depuis le réseau local.

Dans d'autres, ils sont totalement désactivés.

Avant toute hypothèse, il fallait simplement répondre à une question.

**Quels ports écoute réellement le projecteur ?**

---

# Pourquoi utiliser Nmap ?

Le choix de Nmap n'est pas anodin.

Depuis plus de vingt ans, Nmap constitue la référence mondiale en matière de découverte réseau.

Son objectif n'est pas uniquement d'identifier les ports ouverts.

Il tente également d'identifier :

- le protocole utilisé ;
- le service correspondant ;
- parfois même la version du logiciel distant.

Autrement dit, Nmap ne répond pas uniquement à la question :

> Quels ports sont ouverts ?

Il cherche également à répondre à :

> Pourquoi ces ports sont-ils ouverts ?

Cette distinction est essentielle.

---

# Notre première hypothèse

Comme sur la majorité des appareils Android, nous pensions naturellement que si ADB était activé, il écouterait sur le port TCP **5555**.

Ce port est utilisé par Android Debug Bridge depuis de nombreuses années.

Une connexion directe aurait immédiatement permis de confirmer sa présence.

Malheureusement, les premiers essais furent infructueux.

Aucune réponse.

Aucune bannière.

Aucun démon.

Deux hypothèses devenaient alors possibles.

La première :

ADB était totalement désactivé.

La seconde :

ADB existait toujours, mais n'utilisait plus son port habituel.

Aucune des deux ne pouvait encore être privilégiée.

---

# Changer de stratégie

Plutôt que d'insister sur une hypothèse particulière, nous avons décidé de laisser parler les faits.

La meilleure solution consistait à abandonner l'idée de rechercher un service précis.

À la place, nous allions cartographier l'ensemble des services exposés par l'appareil.

C'est exactement le rôle d'un scan réseau.

Notre objectif n'était plus de trouver ADB.

Notre objectif devenait beaucoup plus large :

> découvrir tout ce que le projecteur accepte de révéler.

---

# Le premier scan

Le premier balayage réseau fut volontairement prudent.

Aucun paquet agressif.

Aucune tentative d'exploitation.

Uniquement de l'observation.

Le projecteur répondait correctement sur le réseau local.

L'adresse IP était stable.

Le scan pouvait commencer.

Progressivement, les résultats apparurent.

La majorité des ports étaient fermés.

Puis un port inattendu attira immédiatement notre attention.

```
3268/tcp
```

Ce résultat fut une surprise.

3268 n'est absolument pas un port habituellement associé à Android.

---

# Une première interprétation trompeuse

Comme toujours, Nmap tenta immédiatement d'identifier le service correspondant.

Le résultat affiché fut :

```
globalcatLDAP?
```

Le point d'interrogation est extrêmement important.

Il signifie que Nmap ne possède pas suffisamment d'informations pour identifier le service avec certitude.

Autrement dit, il ne dit pas :

> C'est LDAP.

Il dit :

> Cela ressemble éventuellement à LDAP.

Cette nuance est fondamentale.

Beaucoup d'utilisateurs interprètent à tort cette ligne comme une identification certaine.

En réalité, il ne s'agit que d'une hypothèse produite par le moteur de fingerprinting.

---

# Pourquoi Nmap s'est trompé

Pour comprendre cette erreur, il faut expliquer brièvement le fonctionnement interne de Nmap.

Lorsqu'il identifie un service, Nmap ne lit pas son nom.

Il compare les réponses du serveur avec une gigantesque base de signatures.

Certaines réponses ressemblent davantage à un serveur HTTP.

D'autres ressemblent à SSH.

D'autres encore évoquent LDAP.

Dans notre cas, les premières réponses du démon étaient suffisamment atypiques pour que Nmap les rapproche du protocole Global Catalog LDAP.

Ce rapprochement était pourtant faux.

Le service n'avait absolument rien à voir avec Active Directory.

Il fallait donc poursuivre l'enquête.

---

# Vérifier l'hypothèse

À partir de cet instant, une idée commença à émerger.

Et si ce port ne servait pas LDAP…

…mais Android Debug Bridge ?

Cette hypothèse pouvait sembler audacieuse.

Pourtant, certains constructeurs OEM déplacent volontairement ADB vers un port inhabituel.

Les raisons peuvent être multiples :

- éviter les scans automatiques ;
- réduire les tentatives de connexion non autorisées ;
- conserver une interface de maintenance interne ;
- réutiliser une configuration constructeur.

Une seule manière permettait de trancher.

Tester directement une connexion ADB.

---

# La découverte

Quelques secondes plus tard, la réponse arriva.

Le démon acceptait la connexion.

ADB fonctionnait parfaitement.

Le port 3268 n'hébergeait donc pas un serveur LDAP.

Il hébergeait bien Android Debug Bridge.

Cette découverte changeait complètement la suite du projet.

Nous disposions désormais d'un accès direct au système.

Sans ouvrir le projecteur.

Sans démonter le matériel.

Sans câble UART.

Sans exploit.

Simplement grâce à une observation méthodique du réseau.

---

# Pourquoi cette découverte est importante

Cette étape constitue probablement le véritable point de départ de toute cette enquête.

Sans cet accès ADB :

- aucune analyse des partitions n'aurait été possible ;
- aucune sauvegarde n'aurait été réalisée ;
- aucun composant OEM n'aurait pu être étudié ;
- aucune reconstruction de firmware n'aurait été envisageable.

Autrement dit, toute la suite de ce livre repose indirectement sur cette découverte.

---

# Ce que nous savons désormais

## Faits

- le port TCP 5555 n'était pas utilisé ;
- le port TCP 3268 était ouvert ;
- Nmap proposait une identification incertaine (`globalcatLDAP?`) ;
- une connexion ADB sur ce port fonctionnait correctement.

## Déductions

Le constructeur a très probablement choisi un port non standard pour exposer le démon ADB.

Ce choix complique les découvertes accidentelles, mais ne constitue pas une mesure de sécurité à proprement parler.

## Hypothèses

À ce stade, nous ignorons encore si ce changement de port résulte d'une modification volontaire du constructeur, d'une configuration héritée d'un firmware de développement ou d'une personnalisation apportée par un intégrateur OEM.

Les chapitres suivants permettront de recueillir de nouveaux indices.

---

# Conclusion

Cette découverte illustre parfaitement l'importance de la méthode.

Nous étions partis à la recherche d'un démon ADB.

Nous avons finalement trouvé un port réseau inconnu.

Puis une fausse piste LDAP.

Enfin, un accès complet au système Android.

Ce résultat n'est pas le fruit du hasard.

Il est la conséquence directe d'une démarche consistant à observer avant d'interpréter.

La prochaine étape consistera désormais à exploiter cet accès privilégié pour commencer à cartographier le système Android lui-même.

---

> [!NOTE]
> Le comportement décrit dans ce chapitre concerne exclusivement le firmware étudié. Rien ne garantit que d'autres variantes du HY300 exposent ADB sur le même port.