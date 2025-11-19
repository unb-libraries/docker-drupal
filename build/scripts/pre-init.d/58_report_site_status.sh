#!/usr/bin/env sh
if [ ! -f /tmp/DRUPAL_DB_LIVE ] && [ ! -f /tmp/DRUPAL_FILES_LIVE ];
then
  echo "New installation detected..."
elif [ -f /tmp/DRUPAL_DB_LIVE ] && [ -f /tmp/DRUPAL_FILES_LIVE ];
then
  # Site Needs Upgrade
  echo "Existing installation detected..."
else
  # Inconsistency detected, do nothing to avoid data loss.
  echo "[Error] Something seems odd with the Database and Filesystem..."
  echo "Database Live: $( [ -f /tmp/DRUPAL_DB_LIVE ] && echo 'Yes' || echo 'No' )"
  echo "Files Live: $( [ -f /tmp/DRUPAL_FILES_LIVE ] && echo 'Yes' || echo 'No' )"
  exit 1
fi
