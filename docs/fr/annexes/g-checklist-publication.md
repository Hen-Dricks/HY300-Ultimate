---
title: "Annexe G — Checklist de publication"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "fr"
last_updated: "2026-07-14"
---

# Annexe G — Checklist de publication

> *« Une bonne publication n'est pas seulement une build qui démarre. C'est une build testée, documentée, vérifiée et reproductible. »*

---

# Objectif

Cette checklist constitue la procédure officielle de validation avant toute publication d'une nouvelle version de **HY300 Ultimate**.

Elle permet de garantir :

- la stabilité de la build ;
- l'intégrité des artefacts ;
- la qualité de la documentation ;
- la reproductibilité des résultats.

---

# 1. Validation du firmware

## Démarrage

- [ ] Le système démarre sans erreur.
- [ ] Aucun bootloop observé.
- [ ] Temps de démarrage conforme aux attentes.

---

## Interface

- [ ] Launcher opérationnel.
- [ ] Navigation fluide.
- [ ] Paramètres accessibles.
- [ ] Barre de notifications fonctionnelle.

---

## Matériel

- [ ] HDMI fonctionnel.
- [ ] Wi-Fi fonctionnel.
- [ ] Bluetooth fonctionnel.
- [ ] Audio fonctionnel.
- [ ] Télécommande reconnue.
- [ ] USB reconnu.
- [ ] Stockage interne accessible.
- [ ] Carte microSD détectée.

---

## Fonctions spécifiques

- [ ] Keystone testé.
- [ ] Autofocus testé.
- [ ] Rotation de l'image vérifiée.
- [ ] Projection validée.

---

# 2. Validation des partitions

- [ ] Toutes les partitions sont présentes.
- [ ] `super.img` reconstruite correctement.
- [ ] `system.img` validée.
- [ ] `vendor.img` validée.
- [ ] `product.img` validée.
- [ ] `odm.img` validée.
- [ ] `vbmeta.img` cohérente.

---

# 3. Vérification des systèmes de fichiers

- [ ] `e2fsck` exécuté.
- [ ] Aucune erreur ext4 restante.
- [ ] Taille des partitions vérifiée.
- [ ] Images montables.

---

# 4. Intégrité

- [ ] SHA-256 calculé.
- [ ] SHA-256 vérifié.
- [ ] SHA256SUMS généré.
- [ ] Taille des artefacts contrôlée.

---

# 5. Performances

- [ ] Temps de boot mesuré.
- [ ] RAM comparée à la baseline.
- [ ] CPU au repos contrôlé.
- [ ] Services actifs vérifiés.
- [ ] Aucune régression identifiée.

---

# 6. Journaux

- [ ] Aucun crash critique.
- [ ] `logcat` vérifié.
- [ ] `dmesg` vérifié.
- [ ] Tombstones examinés.

---

# 7. Sécurité

- [ ] SELinux dans l'état prévu.
- [ ] Vérification AVB documentée.
- [ ] Permissions critiques contrôlées.
- [ ] Applications OEM analysées.

---

# 8. Documentation

## Documentation générale

- [ ] README mis à jour.
- [ ] CHANGELOG mis à jour.
- [ ] RELEASE.md rédigé.
- [ ] INSTALL.md vérifié.

---

## Documentation technique

- [ ] Nouveaux chapitres relus.
- [ ] Schémas mis à jour.
- [ ] Captures d'écran ajoutées.
- [ ] Scripts documentés.

---

# 9. Dépôt Git

- [ ] Tous les fichiers sont versionnés.
- [ ] Aucun fichier temporaire.
- [ ] `.gitignore` vérifié.
- [ ] Commit final réalisé.
- [ ] Tag de version créé.

---

# 10. Artefacts

- [ ] Firmware généré.
- [ ] Scripts inclus.
- [ ] Docker validé.
- [ ] Hashes publiés.

---

# 11. Tests finaux

- [ ] Installation complète testée.
- [ ] Redémarrage testé.
- [ ] Réinitialisation testée (si applicable).
- [ ] Utilisation prolongée validée.
- [ ] Régression fonctionnelle absente.

---

# 12. Publication

- [ ] Release GitHub créée.
- [ ] Notes de version publiées.
- [ ] Hashes publiés.
- [ ] Documentation synchronisée.
- [ ] Numéro de version cohérent.

---

# Validation finale

| Élément       | Statut |
| ------------- | :----: |
| Build         |   ☐    |
| Documentation |   ☐    |
| Validation    |   ☐    |
| Tests         |   ☐    |
| Hashes        |   ☐    |
| Publication   |   ☐    |

---

# Signature de la release

**Projet :**

HY300 Ultimate

**Version :**

____________________

**Date :**

____________________

**Auteur :**

____________________

**Firmware de base :**

____________________

**SHA-256 principal :**

____________________

---

# Historique des publications

| Version | Date | Statut            | Validation |
| ------- | ---- | ----------------- | ---------- |
| v0.1    |      | Prototype         |            |
| v0.2    |      | Experimental      |            |
| v0.3    |      | Experimental      |            |
| RC1     |      | Release Candidate |            |
| v1.0    |      | Stable            |            |

---

# Critères d'acceptation

Une build est considérée comme prête à être publiée lorsque :

- toutes les vérifications critiques sont validées ;
- les tests fonctionnels sont concluants ;
- les artefacts sont intègres ;
- la documentation est à jour ;
- les limitations connues sont clairement identifiées.

Une validation incomplète doit conduire au report de la publication jusqu'à résolution des points bloquants.

---

> [!IMPORTANT]
> Cette checklist est volontairement exigeante. Elle ne vise pas à ralentir le développement, mais à garantir que chaque version de HY300 Ultimate soit publiée avec le même niveau de qualité, de traçabilité et de transparence que les précédentes.