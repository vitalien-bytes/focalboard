#!/bin/sh

# Crée le dossier config
mkdir -p /app/config

# Crée un fichier config.json si manquant
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

echo "✅ Configuration générée."
echo "🚀 Lancement du serveur Focalboard..."

# Démarre le serveur Focalboard (binaire Go)
./bin/focalboard-server --config /app/config/config.json
