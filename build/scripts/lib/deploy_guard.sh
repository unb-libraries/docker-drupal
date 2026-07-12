#!/usr/bin/env sh
# Shared helpers for the once-per-deployment gate (see pre-init.d/74_run_deploy_phase.sh).
#
# Records the last successfully-deployed build identifier in a dedicated table so the
# heavy, mutating deploy steps (deploy.d/*) run once per deployment instead of on every
# container boot.

# Table name honors DRUPAL_DB_PREFIX so it can never collide in a prefixed multi-install DB.
DEPLOY_STATE_TABLE="${DRUPAL_DB_PREFIX}deployment_state"

# Run SQL against the site database via the raw mariadb client.
_deploy_guard_sql() {
  mariadb \
    --host="$DRUPAL_DB_HOSTNAME" \
    --port="$DRUPAL_DB_PORT" \
    --user="$DRUPAL_DB_USER" \
    --password="$DRUPAL_DB_PASSWORD" \
    --database="$DRUPAL_DB_NAME" \
    --skip-column-names --batch "$@"
}

# Strip everything outside [A-Za-z0-9._-] before interpolating into SQL.
_deploy_guard_safe() {
  printf '%s' "$1" | tr -cd 'A-Za-z0-9._-'
}

# Create the marker table and seed row if absent. Cheap no-op once created.
deploy_guard_ensure_table() {
  _deploy_guard_sql --execute="
    CREATE TABLE IF NOT EXISTS \`${DEPLOY_STATE_TABLE}\` (
      id                        TINYINT      NOT NULL DEFAULT 1 PRIMARY KEY,
      last_completed_identifier VARCHAR(255) NULL
    );
    INSERT IGNORE INTO \`${DEPLOY_STATE_TABLE}\` (id) VALUES (1);"
}

# Echo the last successfully-deployed identifier (empty string if none recorded yet).
deploy_guard_last_completed() {
  RESULT=$(_deploy_guard_sql --execute="
    SELECT last_completed_identifier FROM \`${DEPLOY_STATE_TABLE}\` WHERE id = 1;")
  # --skip-column-names prints a NULL column as the literal string 'NULL'; normalize it.
  if [ "$RESULT" = "NULL" ]; then
    RESULT=""
  fi
  printf '%s' "$RESULT"
}

# Record the given build identifier as the last successfully-deployed one.
deploy_guard_mark_complete() {
  SAFE_ID=$(_deploy_guard_safe "$1")
  _deploy_guard_sql --execute="
    UPDATE \`${DEPLOY_STATE_TABLE}\` SET last_completed_identifier = '${SAFE_ID}' WHERE id = 1;"
}
