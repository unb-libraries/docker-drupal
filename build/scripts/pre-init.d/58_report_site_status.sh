#!/usr/bin/env sh
if [ ! -f /tmp/DRUPAL_DB_LIVE && ! -f /tmp/DRUPAL_FILES_LIVE ];
then
  echo "New installation detected..."
elif [ -f /tmp/DRUPAL_DB_LIVE && -f /tmp/DRUPAL_FILES_LIVE ];
then
  # Site Needs Upgrade
  echo "Existing installation detected..."

  # Ensure the database details are still valid.
  sed -i "s|'host' => '.*',|'host' => '$MYSQL_HOSTNAME',|g" "$DRUPAL_ROOT/sites/default/settings.php"
  sed -i "s|'port' => '[0-9]\{2,4\}',|'port' => '$MYSQL_PORT',|g" "$DRUPAL_ROOT/sites/default/settings.php"
else
  # Inconsistency detected, do nothing to avoid data loss.
  echo "[Error] Something seems odd with the Database and Filesystem..."
fi
