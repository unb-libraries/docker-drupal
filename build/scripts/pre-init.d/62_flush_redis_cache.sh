#!/usr/bin/env sh
# Flush site-prefixed Redis keys after base settings (including Redis config)
# are applied. Prevents stale cache to read incorrect module/config state.
#
# Uses redis-cli directly because drush cr may fail to bootstrap if the
# cached core.extension references modules that no longer exist.

# Only needed after a fresh install (Redis has stale data, DB/files are new).
# If both DB and files were already live, the Redis cache is current.
[ -f /tmp/DRUPAL_DB_LIVE ] && [ -f /tmp/DRUPAL_FILES_LIVE ] && exit 0

# Skip if Redis module is not installed or redis-cli is not available.
[ -d "$DRUPAL_ROOT/modules/contrib/redis" ] || exit 0
command -v redis-cli >/dev/null 2>&1 || exit 0
[ -n "$DRUPAL_REDIS_HOSTNAME" ] || exit 0

REDIS_PORT="${DRUPAL_REDIS_PORT:-6379}"
CACHE_PREFIX="${DRUPAL_SITE_ID:+${DRUPAL_SITE_ID}_}"

if [ -n "$CACHE_PREFIX" ]; then
  echo "Flushing Redis keys with prefix '${CACHE_PREFIX}'..."
  redis-cli -h "$DRUPAL_REDIS_HOSTNAME" -p "$REDIS_PORT" --scan --pattern "${CACHE_PREFIX}*" | \
    xargs -r redis-cli -h "$DRUPAL_REDIS_HOSTNAME" -p "$REDIS_PORT" DEL 2>/dev/null || true
else
  echo "Warning: DRUPAL_SITE_ID not set, skipping Redis flush (cannot scope by prefix)."
fi
