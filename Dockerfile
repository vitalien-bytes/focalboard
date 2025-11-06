FROM mattermost/focalboard:latest

# Copie la configuration et le script
COPY config.json /opt/focalboard/config.json
COPY entrypoint.sh /entrypoint.sh

# Donne les droits d’exécution
RUN chmod +x /entrypoint.sh

# Dossier pour la DB locale (non utilisé avec Postgres)
RUN mkdir -p /data

ENTRYPOINT ["/entrypoint.sh"]
