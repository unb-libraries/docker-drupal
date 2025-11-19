#!/usr/bin/env sh
# Triage the build to determine how to deploy.

# Remove possible old file markers to eliminate false positives
rm -rf /tmp/DRUPAL_DB_LIVE
rm -rf /tmp/DRUPAL_FILES_LIVE

# Test DB connection using environment variables, do NOT use Drush as we haven't bootstrapped Drupal.
CONNECTION_TEST=$(mariadb --host="$DRUPAL_DB_HOSTNAME" --port="$DRUPAL_DB_PORT" --user="$DRUPAL_DB_USER" --password="$DRUPAL_DB_PASSWORD" --database="$DRUPAL_DB_NAME" --execute="SELECT 1;" 2>&1)
if echo "$CONNECTION_TEST" | grep -q "ERROR"; then
  echo "Triage : Database connection issue: $CONNECTION_TEST"
else
  TABLE_COUNT=$(mariadb --host="$DRUPAL_DB_HOSTNAME" --port="$DRUPAL_DB_PORT" --user="$DRUPAL_DB_USER" --password="$DRUPAL_DB_PASSWORD" --database="$DRUPAL_DB_NAME" --skip-column-names --execute="SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name LIKE '%node%';" 2>/dev/null)
  if echo "$TABLE_COUNT" | grep -Eq '^[0-9]+$'; then
    if [ "$TABLE_COUNT" -gt 0 ]; then
      touch /tmp/DRUPAL_DB_LIVE
      echo "Triage : Found Drupal Database with $TABLE_COUNT node tables."
    else
      echo "Triage : Connected to database, but no node tables found."
    fi
  else
    echo "Triage : Unexpected result from node table count: '$TABLE_COUNT'"
  fi
fi

# Determine if the site was previously built by checking for settings.php and that a 'files' directory exists under $DRUPAL_PUBLIC_FILES_ROOT.
DRUPAL_PUBLIC_FILES_ROOT="$DRUPAL_ROOT/sites/default"
if [ -f "$DRUPAL_PUBLIC_FILES_ROOT/settings.php" ] && [ -d "$DRUPAL_PUBLIC_FILES_ROOT/files" ]; then
  touch /tmp/DRUPAL_FILES_LIVE
  echo "Triage : Found Drupal Filesystem: settings.php and 'files' directory."
else
  echo "Triage : settings.php or 'files' directory not found."
fi
