#!/usr/bin/env sh
# Triage the build to determine how to deploy.

# Remove possible old file markers to eliminate false positives
rm -rf /tmp/DRUPAL_DB_LIVE
rm -rf /tmp/DRUPAL_FILES_LIVE

# Check if we can connect to the database, and a node table exists.
# DO not use drush as we are unsure of the filesystem state at this point.
# Use the DRUPAL_DB_* environment variables set in the container.
DB_CHECK=$( \
  mysql \
    --host="$DRUPAL_DB_HOSTNAME" \
    --port="$DRUPAL_DB_PORT" \
    --user="$DRUPAL_DB_USER" \
    --password="$DRUPAL_DB_PASSWORD" \
    --database="$DRUPAL_DB_NAME" \
    --execute="SHOW TABLES LIKE 'node';" 2>/dev/null \
)
if [ "$DB_CHECK" = "Tables_in_${DRUPAL_DB_NAME} (node)" ] || [ "$DB_CHECK" = "node" ]; then
  touch /tmp/DRUPAL_DB_LIVE
  echo "Triage : Found Drupal Database with node table."
fi

# Determine if the site was previously built by checking for both .htaccess and settings.php in the public file dir.
if [ -f "$DRUPAL_ROOT/sites/default/files/.htaccess" ] && [ -f "$DRUPAL_ROOT/sites/default/files/settings.php" ]; then
  touch /tmp/DRUPAL_FILES_LIVE
  echo "Triage : Found Drupal Filesystem and settings.php."
fi

