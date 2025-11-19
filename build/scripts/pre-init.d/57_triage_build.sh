#!/usr/bin/env sh
# Triage the build to determine how to deploy.

# Remove possible old file markers to eliminate false positives
rm -rf /tmp/DRUPAL_DB_LIVE
rm -rf /tmp/DRUPAL_FILES_LIVE


# Test DB connection using environment variables, do NOT use Drush as we haven't bootstrapped Drupal.
CONNECTION_TEST=$(mysql --host="$DRUPAL_DB_HOSTNAME" --port="$DRUPAL_DB_PORT" --user="$DRUPAL_DB_USER" --password="$DRUPAL_DB_PASSWORD" --database="$DRUPAL_DB_NAME" --execute="SELECT 1;" 2>&1)
if echo "$CONNECTION_TEST" | grep -q "ERROR"; then
  echo "Triage : Database connection issue: $CONNECTION_TEST"
  echo "Refusing to proceed with build triage."
  exit 1
else
  TABLE_COUNT=$(mysql --host="$DRUPAL_DB_HOSTNAME" --port="$DRUPAL_DB_PORT" --user="$DRUPAL_DB_USER" --password="$DRUPAL_DB_PASSWORD" --database="$DRUPAL_DB_NAME" --skip-column-names --execute="SELECT COUNT(*) FROM information_schema.tables WHERE table_schma = DATABASE() AND table_name LIKE '%node%';" 2>/dev/null)
  if [ "$TABLE_COUNT" -gt 0 ]; then
    touch /tmp/DRUPAL_DB_LIVE
    echo "Triage : Found Drupal Database with $TABLE_COUNT node tables."
  else
    echo "Triage : Connected to database, but no node tables found."
  fi
fi


# Determine if the site was previously built by checking for both .htaccess and settings.php in the public file dir.
if [ -f "$DRUPAL_ROOT/sites/default/files/.htaccess" ] && [ -f "$DRUPAL_ROOT/sites/default/files/settings.php" ]; then
  touch /tmp/DRUPAL_FILES_LIVE
  echo "Triage : Found Drupal Filesystem and settings.php."
else
  echo "Triage : Filesystem and/or settings.php not found."
fi
