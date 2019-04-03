#!/usr/bin/env sh
# Update database if this was a previous deployment.
if [[ -f /tmp/DRUPAL_DB_LIVE && -f /tmp/DRUPAL_FILES_LIVE ]];
then
  echo "Applying database updates to existing instance.."
  ${DRUSH} updb
  ${DRUSH} cache-rebuild
fi
