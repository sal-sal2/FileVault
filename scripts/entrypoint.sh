#!/bin/sh
set -e

echo "Waiting for Postgres..."

# Loop until pg_isready confirms the DB is accepting connections.
# Without this, Django's migrate command races against Postgres startup and fails.
until pg_isready -h "${POSTGRES_HOST:-db}" -p "${POSTGRES_PORT:-5432}" -U "${POSTGRES_USER:-filevault}"; do
  echo "Postgres is unavailable — sleeping 1s"
  sleep 1
done

echo "Postgres is up."

echo "Running migrations..."
python manage.py migrate --noinput

echo "Starting Gunicorn..."
exec gunicorn config.wsgi:application \
  --bind 0.0.0.0:8000 \
  --workers 2 \
  --timeout 120 \
  --access-logfile - \
  --error-logfile -
