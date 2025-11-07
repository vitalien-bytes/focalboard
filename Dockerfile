# Étape 1 : Construire le backend (Go)
FROM golang:1.20-alpine AS backend
WORKDIR /app
RUN apk add --no-cache git make nodejs npm
RUN git clone https://github.com/mattermost/focalboard.git .
RUN make server-linux

# Étape 2 : Construire le frontend (React)
FROM node:18-alpine AS frontend
WORKDIR /app/webapp
COPY --from=backend /app/webapp /app/webapp
RUN npm install && npm run build

# Étape 3 : Image finale légère
FROM alpine:3.18
WORKDIR /app
RUN apk add --no-cache libc6-compat
COPY --from=backend /app/bin/focalboard-server ./bin/focalboard-server
COPY --from=frontend /app/webapp/build ./pack
COPY ./config.json ./config/config.json
EXPOSE 8000
CMD ["./bin/focalboard-server", "--config", "./config/config.json"]
