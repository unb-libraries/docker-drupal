#!/usr/bin/env sh
# Configuration
if [ -d "$DRUPAL_CONFIGURATION_DIR" ] && [ "$(ls $DRUPAL_CONFIGURATION_DIR)" ]; then
  # What is this monstrosity?
  # Why do we import configuration 3 times?
  # See: https://github.com/drush-ops/drush/issues/2449.
  # Also: https://www.drupal.org/project/drupal/issues/3241439
  /scripts/configImport.sh || /scripts/configImport.sh
  /scripts/configImport.sh
fi
