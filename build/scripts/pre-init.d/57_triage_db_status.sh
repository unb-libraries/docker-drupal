#!/usr/bin/env sh
# Triage the database status.

# Remove possible old file marker to eliminate false positives
rm -rf /tmp/DRUPAL_DB_LIVE

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
