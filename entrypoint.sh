#!/bin/sh
set -e
PORT="${PORT:-8000}"
if [ -n "$DB_CONN_STRING" ]; then
  sed -i "s|\"__DB_URL__\"|\"${DB_CONN_STRING}\"|" /opt/focalboard/config.json
fi
sed -i "s/\"port\": *[0-9]\+/\"port\": ${PORT}/" /opt/focalboard/config.json
exec /opt/focalboard/bin/focalboard-server
