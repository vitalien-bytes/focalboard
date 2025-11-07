# Étape 1 : construction complète du serveur Focalboard
FROM golang:1.22-bullseye AS builder

WORKDIR /app

# Installer les dépendances
RUN apt-get update && apt-get install -y make git nodejs npm

# Cloner la source officielle
RUN git clone https://github.com/mattermost/focalboard.git .

# Construire le backend (serveur)
RUN make server-linux

# Étape 2 : image finale allégée
FROM debian:bullseye-slim

WORKDIR /app

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Copier le binaire et les fichiers nécessaires
COPY --from=builder /app/bin/focalboard-server /app/focalboard-server
COPY --from=builder /app/web /app/web
COPY --from=builder /app/packaged /app/packaged

# Ajouter le script d'entrée
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
