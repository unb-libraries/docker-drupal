#!/usr/bin/env sh
# Triage the build to determine how to deploy.

# Remove possible old file markers to eliminate false positives
rm -rf /tmp/DRUPAL_DB_LIVE
rm -rf /tmp/DRUPAL_FILES_LIVE

# Test DB connection
CONNECTION_TEST=$($DRUSH sql-query "SELECT 1;" --skip-column-names 2>&1)
if echo "$CONNECTION_TEST" | grep -q "ERROR"; then
  echo "Triage : Database connection issue: $CONNECTION_TEST"
else
  TABLE_COUNT=$($DRUSH sql-query "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name LIKE '%node%';" --skip-column-names)
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
