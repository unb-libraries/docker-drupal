#!/usr/bin/env sh
# Update database if this was a previous deployment.
if [[ -f /tmp/DRUPAL_DB_LIVE && -f /tmp/DRUPAL_FILES_LIVE ]];
then
  # Apply database updates, if they exist.
  echo "Applying database updates to instance.."
  drush --yes --root=${DRUPAL_ROOT} --uri=default updb
fi
