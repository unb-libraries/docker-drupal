#!/usr/bin/env sh
if [ ! -f /tmp/DRUPAL_DB_LIVE ]  && [ ! -f /tmp/DRUPAL_FILES_LIVE ];
then
  $DRUSH en redis
fi
