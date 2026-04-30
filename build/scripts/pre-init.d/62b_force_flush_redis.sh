#!/usr/bin/env sh
# Force-flush site-prefixed Redis keys on every boot.
#
# Why: parent 62_flush_redis_cache.sh short-circuits when both DB and files
# are live, which misses the same-DB+files-but-NEW-IMAGE deploy case. In that
# case Redis still holds container/plugin/twig caches keyed against the OLD
# image's classes, and downstream pre-init steps (76 sync_extensions,
# 78 run_update_hooks, 79 import_configuration) can fatal during bootstrap
# before 94_clear_cache gets a chance to run.
#
# Cost: one SCAN+UNLINK round-trip per boot — fast on a shared instance.
set -e
[ -n "${DRUPAL_SITE_ID:-}" ] || exit 0
[ -n "${DRUPAL_REDIS_HOSTNAME:-}" ] || exit 0
command -v redis-cli >/dev/null 2>&1 || exit 0
/scripts/flushRedisCache.sh
