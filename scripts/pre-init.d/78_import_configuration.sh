#!/usr/bin/env sh
# Configuration
if [ -d "$DRUPAL_CONFIGURATION_DIR" ] && [ "$(ls $DRUPAL_CONFIGURATION_DIR)" ]; then
  /scripts/configImport.sh
fi
