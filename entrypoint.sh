#!/bin/sh

# Crée le dossier s'il n'existe pas
mkdir -p /app/config

# Crée le fichier config.json s'il n'existe pas
if [ ! -f /app/config/config.json ]; then
  cat <<EOF > /app/config/config.json
{
  "serverRoot": "https://focalboard-dtn.onrender.com",
  "port": 8000,
  "dbtype": "postgres",
  "dbconfig": "${DB_CONN_STRING}",
  "useSSL": true
}
EOF
fi

# Lance le serveur Focalboard
echo "🚀 Démarrage du serveur Focalboard..."
npm start
