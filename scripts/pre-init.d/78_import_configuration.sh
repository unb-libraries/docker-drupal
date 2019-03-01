#!/usr/bin/env sh
# Configuration
if [ "$DRUPAL_DEPLOY_CONFIGURATION" != "FALSE" ] && [ -d "$DRUPAL_CONFIGURATION_DIR" ] && [ "$(ls $DRUPAL_CONFIGURATION_DIR)" ]; then
  /scripts/configImport.sh
  drush --root=${DRUPAL_ROOT} --uri=default --yes cache-rebuild
fi
