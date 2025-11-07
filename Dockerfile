# ---- Étape 1 : Build du serveur Focalboard (backend + frontend)
FROM golang:1.22-alpine AS builder

# Installer les dépendances nécessaires
RUN apk add --no-cache git make nodejs npm bash

# Créer le répertoire de travail
WORKDIR /app

# Cloner le dépôt officiel Focalboard
RUN git clone https://github.com/mattermost/focalboard.git .

# Construire le serveur
RUN make server-linux || make build-linux

# ---- Étape 2 : Image finale légère
FROM alpine:latest

# Installer les dépendances minimales
RUN apk add --no-cache libc6-compat

# Créer le répertoire de travail
WORKDIR /app

# Copier les fichiers compilés depuis la première étape
COPY --from=builder /app /app

# Copier le fichier de configuration local
COPY ./config.json ./config/config.json

# Exposer le port par défaut
EXPOSE 8000

# Démarrer Focalboard
CMD ["./bin/focalboard-server", "--config", "./config/config.json"]
