# Étape 1 : base image
FROM node:18-alpine AS build

# Dossier de travail
WORKDIR /app

# Copie du contenu du projet
COPY . .

# Donne les droits d'exécution dès la copie
RUN dos2unix entrypoint.sh && chmod 755 entrypoint.sh

# Étape 2 : exécution
FROM alpine:3.18

# Installer bash, node et dépendances
RUN apk add --no-cache bash nodejs npm

# Dossier de travail
WORKDIR /app

# Copier les fichiers de build
COPY --from=build /app /app

# Port exposé
EXPOSE 8000

# Commande de démarrage
ENTRYPOINT ["sh", "./entrypoint.sh"]
