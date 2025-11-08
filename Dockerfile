# Étape 1 : Construction du serveur Focalboard
FROM golang:1.21 AS builder

WORKDIR /app

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y make git nodejs npm

# Cloner le dépôt Focalboard (version open source)
RUN git clone https://github.com/mattermost/focalboard.git .
RUN make server-linux

# Étape 2 : Image finale allégée
FROM debian:bullseye-slim

WORKDIR /app

# Copier les fichiers compilés depuis la première étape
COPY --from=builder /app/bin/focalboard-server ./bin/focalboard-server
COPY --from=builder /app/webapp ./webapp
COPY --from=builder /app/config ./config

# Exposer le port
ENV PORT=8000
EXPOSE 8000

# Lancer le serveur
CMD ["./bin/focalboard-server", "--config", "./config/config.json"]
