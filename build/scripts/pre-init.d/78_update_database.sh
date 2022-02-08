#!/usr/bin/env sh
# Apply any necessary database updates.
if [ -f /tmp/DRUPAL_DB_LIVE ]  && [ -f /tmp/DRUPAL_FILES_LIVE ];
then
  echo "Applying database updates to existing instance..."
  $DRUSH updb
fi
