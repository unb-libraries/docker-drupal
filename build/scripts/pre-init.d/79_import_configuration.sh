#!/usr/bin/env sh
# Configuration
if [ -d "$DRUPAL_CONFIGURATION_DIR" ] && [ "$(ls $DRUPAL_CONFIGURATION_DIR)" ]; then
  # What is this monstrosity? See https://github.com/drush-ops/drush/issues/2449.
  /scripts/configImport.sh || /scripts/configImport.sh
  /scripts/configImport.sh
fi
