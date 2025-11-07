#!/bin/bash
set -e

echo "🧠 Configuration du serveur Focalboard..."

mkdir -p /app/config

cat <<EOF > /app/config/config.json
{
  "serverRoot": "https://focalboard-dtn.onrender.com",
  "port": 8000,
  "dbtype": "postgres",
  "dbconfig": "${DB_CONN_STRING}",
  "useSSL": true,
  "telemetry": false
}
EOF

echo "✅ Fichier config généré."
echo "🚀 Lancement du serveur Focalboard..."
/app/focalboard-server --config /app/config/config.json
