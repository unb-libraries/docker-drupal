#!/usr/bin/env sh
# Configuration
if [ "$DRUPAL_DEPLOY_CONFIGURATION" != "FALSE" ] && [ -d "$DRUPAL_CONFIGURATION_DIR" ] && [ "$(ls $DRUPAL_CONFIGURATION_DIR)" ]; then
  /scripts/configImport.sh
  ${DRUSH} cache-rebuild
fi
