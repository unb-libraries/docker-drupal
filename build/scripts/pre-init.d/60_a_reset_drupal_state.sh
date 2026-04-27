#!/usr/bin/env sh
# Resets Drupal state (DB + filesystem) when armed.
#
# Slots between 59_configure_database_settings.sh and 60_install_drupal.sh.
# After we wipe and clear the LIVE flags, the base image's install_drupal
# performs a fresh install; 62_flush_redis_cache.sh handles Redis afterward.
#
# Trigger:
#   DRUPAL_RESET_ON_INIT=DESTROY_ALL_DATA   (exact string, case-sensitive)
#
#   ENV is the trigger because:
#     - It survives `docker compose up --force-recreate` and down/up cycles
#       (compose.yml is the source of truth, re-applied on every container
#       creation), unlike a file in the writable layer.
#     - It cannot be modified by anything inside the container -- nginx user,
#       Drupal code, an attacker via file upload, etc. Only the operator can
#       set it via the compose stack definition.
#
# Tunable:
#   DRUPAL_RESET_DELAY_SECONDS=300   (numeric, default 300; abort window)
#
# Disarm:
#   On success, writes a marker at $DRUPAL_ROOT/sites/default/files/.drupal_reset_done.
#   Subsequent boots with the ENV still set are no-ops while the marker exists.
#   Re-arm by removing the marker, or by recreating the container after also
#   wiping the files volume.
set -e

# 1. Gate.
[ "${DRUPAL_RESET_ON_INIT:-}" = "DESTROY_ALL_DATA" ] || exit 0

# 2. Sanity-check DRUPAL_ROOT (defense in depth; 50_validate_required_vars.sh
#    has already covered the core vars by the time we run).
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

# 4. Fresh-install short-circuit. Triage at 51_/57_/58_ has run; if neither
#    LIVE flag is set there's nothing to reset. No marker is written so a
#    later boot after content/files exist will still run a real reset.
if [ ! -f /tmp/DRUPAL_DB_LIVE ] && [ ! -f /tmp/DRUPAL_FILES_LIVE ]; then
  echo "[reset] no LIVE flags from triage -- treating as fresh install, no-op exit"
  exit 0
fi

# 5. Validate delay (POSIX-portable; hard fail on non-numeric so typos surface).
DELAY="${DRUPAL_RESET_DELAY_SECONDS:-300}"
case "$DELAY" in
  ''|*[!0-9]*)
    echo "[reset] DRUPAL_RESET_DELAY_SECONDS must be a non-negative integer (got: '$DELAY')"
    exit 1
    ;;
esac

# 6. Banner.
echo "############################################################"
echo "# DRUPAL RESET ARMED -- DESTRUCTIVE ACTION INCOMING"
echo "#"
echo "# Container:  ${HOSTNAME:-unknown}"
echo "# Site ID:    ${DRUPAL_SITE_ID:-unset}"
echo "# Targets:"
echo "#   DB:       drush sql-drop -y"
echo "#   Public:   $PUBLIC_FILES"
echo "#   Private:  ${DRUPAL_PRIVATE_FILE_PATH:-(unset -- skip)}"
echo "#"
echo "# Wiping in ${DELAY}s. docker stop to abort."
echo "############################################################"

# 7. Countdown.
i="$DELAY"
while [ "$i" -gt 0 ]; do
  echo "[reset] wiping in $i..."
  sleep 1
  i=$((i - 1))
done

# 8. DB drop. (DB connectivity already validated by 55_wait_for_mysql_server.sh.)
echo "[reset] dropping all DB tables"
$DRUSH sql-drop -y

# 9. Public files wipe.
if [ -d "$PUBLIC_FILES" ]; then
  echo "[reset] wiping public files: $PUBLIC_FILES"
  find "$PUBLIC_FILES" -mindepth 1 -delete
fi

# 10. Private files wipe.
if [ -n "${DRUPAL_PRIVATE_FILE_PATH:-}" ] && [ -d "$DRUPAL_PRIVATE_FILE_PATH" ]; then
  echo "[reset] wiping private files: $DRUPAL_PRIVATE_FILE_PATH"
  find "$DRUPAL_PRIVATE_FILE_PATH" -mindepth 1 -delete
fi

# 11. Clear LIVE flags so 60_install_drupal.sh fresh-installs and
#     62_flush_redis_cache.sh runs its post-install branch.
rm -f /tmp/DRUPAL_DB_LIVE /tmp/DRUPAL_FILES_LIVE

# 12. Write marker on the persistent files volume. importFiles.sh preserves
#     this marker across re-imports so post-import boots don't re-reset.
mkdir -p "$PUBLIC_FILES"
{
  echo "Reset performed at $(date -Iseconds 2>/dev/null || date)"
  echo "Container: ${HOSTNAME:-unknown}"
  echo "DRUPAL_SITE_ID: ${DRUPAL_SITE_ID:-unset}"
  echo "To re-arm: rm $MARKER"
} > "$MARKER"

echo "[reset] complete. To re-arm: rm $MARKER"
