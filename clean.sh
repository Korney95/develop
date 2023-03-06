#!/usr/bin/env bash


set -euo pipefail

readonly DIRECTORY="${AIRFLOW_HOME:-/usr/local/airflow}"
readonly RETENTION="${AIRFLOW__LOG_RETENTION_DAYS:-15}"

trap "exit" INT TERM

readonly EVERY=$((15*60))

echo "Cleaning logs every $EVERY seconds"

while true; do
  echo "Trimming airflow logs to ${RETENTION} days."
  find "${DIRECTORY}"/logs \
    -type d -name 'lost+found' -prune -o \
    -type f -cmin +1 -name '*.log' -print0 | \
    xargs -0 rm -f

  seconds=$(( $(date -u +%s) % EVERY))
  (( seconds < 1 )) || sleep $((EVERY - seconds))
done
