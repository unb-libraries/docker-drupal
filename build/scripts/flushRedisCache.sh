#!/usr/bin/env sh
set -eu
set -o pipefail
: "${DRUPAL_SITE_ID:?DRUPAL_SITE_ID is required}"
: "${DRUPAL_REDIS_HOSTNAME:?DRUPAL_REDIS_HOSTNAME is required}"

PATTERN="${DRUPAL_SITE_ID}_*"

# SCAN cost is O(total keys in the instance), not O(matched keys), because the
# server walks the whole keyspace and filters by pattern. On a shared instance
# the default COUNT hint of 10 means ~N/10 round-trips, which dominates startup
# time. A larger COUNT trades a slightly bigger per-call payload for ~100x fewer
# round-trips. UNLINK (async free) keeps deletion off the main thread.
SCAN_COUNT="${DRUPAL_REDIS_SCAN_COUNT:-1000}"

total=$(
  redis-cli -h "$DRUPAL_REDIS_HOSTNAME" --scan --pattern "$PATTERN" --count "$SCAN_COUNT" \
    | tr '\n' '\0' \
    | xargs -0 -r -n 500 redis-cli -h "$DRUPAL_REDIS_HOSTNAME" UNLINK \
    | awk '{s+=$1} END {print s+0}'
)

echo "Flushed $total Redis keys matching $PATTERN"
