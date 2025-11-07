# ---- Étape 1 : Build du serveur Focalboard (backend Go + frontend React)
FROM golang:1.20-alpine AS builder

# Installer les dépendances nécessaires
RUN apk add --no-cache git make nodejs npm

# Créer le répertoire de travail
WORKDIR /app

# Cloner le dépôt officiel Focalboard
RUN git clone https://github.com/mattermost/focalboard.git .

# Construire le serveur (backend + frontend)
RUN make server-linux

# ---- Étape 2 : Image finale légère
FROM alpine:latest

# Installer les dépendances minimales
RUN apk add --no-cache libc6-compat

# Créer le répertoire de travail
WORKDIR /app

# Copier les fichiers compilés depuis la première étape
COPY --from=builder /app /app

# Copier ton fichier de configuration
COPY ./config.json ./config/config.json

# Exposer le port utilisé par Focalboard
EXPOSE 8000

# Démarrer le serveur Focalboard
CMD ["./bin/focalboard-server", "--config", "./config/config.json"]
