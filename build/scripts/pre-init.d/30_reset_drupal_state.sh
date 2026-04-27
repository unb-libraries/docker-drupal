#!/usr/bin/env sh
# Resets Drupal state (DB + filesystem + Redis) when armed.
# Arm:    DRUPAL_RESET_ON_INIT=DESTROY_ALL_DATA   (exact string, case-sensitive)
# Delay:  DRUPAL_RESET_DELAY_SECONDS=30           (numeric, default 30)
# Marker: $DRUPAL_ROOT/sites/default/files/.drupal_reset_done
# Re-arm: remove the marker file.
set -e

# 1. Gate.
[ "${DRUPAL_RESET_ON_INIT:-}" = "DESTROY_ALL_DATA" ] || exit 0

# 2. Sanity-check DRUPAL_ROOT.
if [ -z "${DRUPAL_ROOT:-}" ] || [ ! -d "$DRUPAL_ROOT" ]; then
  echo "[reset] DRUPAL_ROOT is unset or not a directory (got: '${DRUPAL_ROOT:-}') -- aborting"
  exit 1
fi

PUBLIC_FILES="$DRUPAL_ROOT/sites/default/files"
MARKER="$PUBLIC_FILES/.drupal_reset_done"

# 3. Disarm check (persistent marker on the files volume).
if [ -f "$MARKER" ]; then
  echo "[reset] marker present at $MARKER -- skipping"
  exit 0
fi

# 4. Validate delay (POSIX-portable; hard fail on non-numeric).
DELAY="${DRUPAL_RESET_DELAY_SECONDS:-300}"
case "$DELAY" in
  ''|*[!0-9]*)
    echo "[reset] DRUPAL_RESET_DELAY_SECONDS must be a non-negative integer (got: '$DELAY')"
    exit 1
    ;;
esac

# 5. Banner.
echo "############################################################"
echo "# DRUPAL RESET ARMED -- DESTRUCTIVE ACTION INCOMING        #"
echo "#                                                          #"
echo "# Container:  ${HOSTNAME:-unknown}"
echo "# Site ID:    ${DRUPAL_SITE_ID:-unset}"
echo "# Targets:                                                 #"
echo "#   DB:       drush sql-drop -y                            #"
echo "#   Public:   $PUBLIC_FILES"
echo "#   Private:  ${DRUPAL_PRIVATE_FILE_PATH:-(unset -- skip)}"
echo "#   Redis:    ${DRUPAL_REDIS_HOSTNAME:-(unset -- skip)}"
echo "#                                                          #"
echo "# Wiping in ${DELAY}s. docker stop to abort.               #"
echo "############################################################"

# 6. Countdown.
i="$DELAY"
while [ "$i" -gt 0 ]; do
  echo "[reset] wiping in $i..."
  sleep 1
  i=$((i - 1))
done

# 7. DB drop (validates DB connectivity before touching the filesystem).
echo "[reset] dropping all DB tables"
$DRUSH sql-drop -y

# 8. Public files wipe.
if [ -d "$PUBLIC_FILES" ]; then
  echo "[reset] wiping public files: $PUBLIC_FILES"
  find "$PUBLIC_FILES" -mindepth 1 -delete
fi

# 9. Private files wipe.
if [ -n "${DRUPAL_PRIVATE_FILE_PATH:-}" ] && [ -d "$DRUPAL_PRIVATE_FILE_PATH" ]; then
  echo "[reset] wiping private files: $DRUPAL_PRIVATE_FILE_PATH"
  find "$DRUPAL_PRIVATE_FILE_PATH" -mindepth 1 -delete
fi

# 10. Redis flush (best-effort; unreachable Redis must not abort the reset).
if [ -n "${DRUPAL_REDIS_HOSTNAME:-}" ]; then
  if redis-cli -h "$DRUPAL_REDIS_HOSTNAME" -t 2 PING >/dev/null 2>&1; then
    echo "[reset] flushing Redis cache"
    /scripts/flushRedisCache.sh
  else
    echo "[reset] redis unreachable at $DRUPAL_REDIS_HOSTNAME -- skipping flush"
  fi
fi

# 11. Clear LIVE flags so downstream pre-init.d treats the container as fresh.
rm -f /tmp/DRUPAL_DB_LIVE /tmp/DRUPAL_FILES_LIVE

# 12. Write marker on the persistent files volume.
mkdir -p "$PUBLIC_FILES"
{
  echo "Reset performed at $(date -Iseconds 2>/dev/null || date)"
  echo "Container: ${HOSTNAME:-unknown}"
  echo "DRUPAL_SITE_ID: ${DRUPAL_SITE_ID:-unset}"
  echo "To re-arm: rm $MARKER"
} > "$MARKER"

# 13. Done.
echo "[reset] complete. To re-arm: rm $MARKER"
