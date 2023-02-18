#!/usr/bin/env sh
if [ ! -f /tmp/DRUPAL_DB_LIVE ] && [ ! -f /tmp/DRUPAL_FILES_LIVE ];
then
  # Enables the default modules.
  $DRUSH en redis

  # Sets the default themes.
  $DRUSH theme:install claro olivero
  $DRUSH config-set system.theme default olivero
  $DRUSH config-set system.theme admin claro
fi
