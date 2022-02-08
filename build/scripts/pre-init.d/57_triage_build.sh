#!/usr/bin/env sh
# Triage the build to determine how to deploy.

# Remove possible old file markers to eliminate false positives
rm -rf /tmp/DRUPAL_DB_LIVE
rm -rf /tmp/DRUPAL_FILES_LIVE

# Check if the database has tables named *node*. If so, this is likely a live DB.
RESULT=$(mysqlshow -h "$MYSQL_HOSTNAME" -P "$MYSQL_PORT" --user="${DRUPAL_SITE_ID}_user" --password="$DRUPAL_DB_PASSWORD" "${DRUPAL_SITE_ID}_db" | grep node)
if [ ! -z "$RESULT" ]; then
  touch /tmp/DRUPAL_DB_LIVE
  echo "Triage : Found Drupal Database."
fi

# Determine if the site was previously built by checking the public file dir.
if [ -f "$DRUPAL_ROOT/sites/default/files/.htaccess" ]; then
  touch /tmp/DRUPAL_FILES_LIVE
  echo "Triage : Found Drupal Filesystem."
fi
