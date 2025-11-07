# Étape 1 : construction complète de Focalboard (serveur + interface)
FROM golang:1.22-bullseye AS builder

WORKDIR /app

# Installer les dépendances
RUN apt-get update && apt-get install -y make git nodejs npm

# Cloner la source officielle
RUN git clone https://github.com/mattermost/focalboard.git .

# Construire le backend et le frontend
RUN make build

# Étape 2 : image finale allégée
FROM debian:bullseye-slim

WORKDIR /app

# Copier le binaire et les fichiers essentiels
COPY --from=builder /app/bin/focalboard-server /app/focalboard-server
COPY --from=builder /app/web /app/web
COPY --from=builder /app/packaged /app/packaged

# Ajouter notre script d’entrée
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
