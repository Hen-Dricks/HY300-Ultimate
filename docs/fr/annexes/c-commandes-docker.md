---
title: "Annexe C — Commandes Docker"
author: "HY300 Ultimate Research"
version: "1.0"
status: "Reference"
language: "fr"
last_updated: "2026-07-14"
---

# Annexe C — Commandes Docker

> *« Docker permet de rendre un environnement de développement reproductible. Ce n'est pas seulement un outil de virtualisation, c'est un moyen de garantir que les mêmes commandes produisent les mêmes résultats sur différentes machines. »*

---

# Objectif

Cette annexe regroupe les principales commandes Docker utilisées tout au long du projet HY300 Ultimate.

L'objectif est de fournir un environnement stable pour :

- manipuler les partitions Android ;
- reconstruire les images système ;
- exécuter les outils Linux nécessaires ;
- garantir la reproductibilité des opérations.

---

# Pourquoi Docker ?

Le développement du projet a été réalisé principalement sous macOS.

Docker permet :

- d'utiliser un environnement Linux identique sur toutes les plateformes ;
- d'éviter les différences entre macOS, Linux et Windows ;
- d'isoler les dépendances du système hôte ;
- de simplifier la reproduction des expérimentations.

---

# Vérifier Docker

Version.

```bash
docker --version
```

Informations générales.

```bash
docker info
```

Version détaillée.

```bash
docker version
```

---

# Images

Lister les images.

```bash
docker images
```

Télécharger une image.

```bash
docker pull ubuntu:24.04
```

Supprimer une image.

```bash
docker rmi IMAGE_ID
```

---

# Conteneurs

Lister les conteneurs actifs.

```bash
docker ps
```

Lister tous les conteneurs.

```bash
docker ps -a
```

Supprimer un conteneur.

```bash
docker rm CONTAINER_ID
```

Supprimer tous les conteneurs arrêtés.

```bash
docker container prune
```

---

# Construire une image

Construction.

```bash
docker build -t hy300 .
```

Construction sans cache.

```bash
docker build --no-cache -t hy300 .
```

---

# Exécuter un conteneur

Mode interactif.

```bash
docker run -it hy300
```

Monter le dossier courant.

```bash
docker run -it \
-v $(pwd):/workspace \
hy300
```

Lancer un shell.

```bash
docker run -it hy300 bash
```

---

# Volumes

Créer un volume.

```bash
docker volume create hy300-data
```

Lister.

```bash
docker volume ls
```

Supprimer.

```bash
docker volume rm hy300-data
```

Les volumes permettent de conserver les données même après la suppression d'un conteneur.

---

# Bind mounts

Partager un dossier local.

```bash
-v $(pwd):/workspace
```

Exemple.

```bash
docker run \
-v $(pwd):/workspace \
-it hy300
```

Cette méthode est utilisée pendant tout le projet.

---

# Copier des fichiers

Vers le conteneur.

```bash
docker cp fichier.img CONTAINER:/workspace/
```

Depuis le conteneur.

```bash
docker cp CONTAINER:/workspace/result.img .
```

---

# Exécuter une commande

Dans un conteneur.

```bash
docker exec -it CONTAINER bash
```

Commande unique.

```bash
docker exec CONTAINER ls
```

---

# Journaux

Afficher.

```bash
docker logs CONTAINER
```

Suivre.

```bash
docker logs -f CONTAINER
```

---

# Docker Compose

Démarrage.

```bash
docker compose up
```

Arrière-plan.

```bash
docker compose up -d
```

Arrêt.

```bash
docker compose down
```

Reconstruire.

```bash
docker compose up --build
```

---

# Nettoyage

Supprimer les objets inutilisés.

```bash
docker system prune
```

Nettoyage complet.

```bash
docker system prune -a
```

Volumes inutilisés.

```bash
docker volume prune
```

---

# Architecture Apple Silicon

Afficher l'architecture.

```bash
uname -m
```

Architecture Docker.

```bash
docker version
```

Exécuter une image x86.

```bash
docker run \
--platform linux/amd64 \
ubuntu
```

---

# Variables d'environnement

Passer une variable.

```bash
docker run \
-e VARIABLE=valeur \
hy300
```

Utiliser un fichier.

```bash
--env-file .env
```

---

# Dockerfile minimal

```dockerfile
FROM ubuntu:24.04

RUN apt update && apt install -y \
    e2fsprogs \
    git \
    wget

WORKDIR /workspace

CMD ["/bin/bash"]
```

---

# Organisation du projet

```
docker/

├── Dockerfile
├── docker-compose.yml
├── scripts/
└── README.md
```

---

# Flux de travail

```
Clone Git

↓

docker build

↓

docker compose up

↓

Extraction

↓

Analyse

↓

Modification

↓

Reconstruction

↓

Validation
```

---

# Tableau récapitulatif

| Action       | Commande              |
| ------------ | --------------------- |
| Version      | `docker --version`    |
| Images       | `docker images`       |
| Conteneurs   | `docker ps`           |
| Construction | `docker build`        |
| Exécution    | `docker run`          |
| Shell        | `docker exec`         |
| Volumes      | `docker volume ls`    |
| Logs         | `docker logs`         |
| Compose      | `docker compose up`   |
| Nettoyage    | `docker system prune` |

---

# Bonnes pratiques

- Utiliser des images Docker versionnées.
- Éviter les dépendances installées directement sur le système hôte.
- Monter le dépôt Git comme volume plutôt que de copier les fichiers.
- Documenter les versions des outils utilisés.
- Conserver les scripts d'installation dans le dépôt.
- Nettoyer régulièrement les images et conteneurs inutilisés.

---

# Commandes réellement utilisées dans HY300 Ultimate

Cette section est destinée à accueillir les commandes effectivement employées pendant le développement.

Elle sera enrichie avec :

- les commandes de construction des images Docker ;
- les montages de volumes utilisés ;
- les paramètres spécifiques à Apple Silicon ;
- les scripts d'automatisation ;
- les journaux de construction.

Cette distinction permet de séparer les commandes de référence des commandes réellement exécutées dans le cadre du projet.

---

# Dépannage rapide

| Problème                 | Cause probable     | Solution                                              |
| ------------------------ | ------------------ | ----------------------------------------------------- |
| Conteneur ne démarre pas | Image absente      | `docker build` ou `docker pull`                       |
| Volume vide              | Mauvais montage    | Vérifier le chemin passé avec `-v`                    |
| Permission refusée       | UID/GID différents | Ajuster les permissions ou l'utilisateur du conteneur |
| Image trop volumineuse   | Couches inutiles   | Nettoyer avec `docker system prune`                   |
| Mauvaise architecture    | Image x86 sur ARM  | Utiliser `--platform linux/amd64` si nécessaire       |