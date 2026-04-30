#!/usr/bin/env sh
set -eu
set -o pipefail
: "${DRUPAL_SITE_ID:?DRUPAL_SITE_ID is required}"
: "${DRUPAL_REDIS_HOSTNAME:?DRUPAL_REDIS_HOSTNAME is required}"

PATTERN="${DRUPAL_SITE_ID}_*"

total=$(
  redis-cli -h "$DRUPAL_REDIS_HOSTNAME" --scan --pattern "$PATTERN" \
    | tr '\n' '\0' \
    | xargs -0 -r -n 200 redis-cli -h "$DRUPAL_REDIS_HOSTNAME" UNLINK \
    | awk '{s+=$1} END {print s+0}'
)

echo "Flushed $total Redis keys matching $PATTERN"
