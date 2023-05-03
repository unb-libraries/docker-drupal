#!/usr/bin/env sh
/scripts/setConfigDirPermissions.sh
rm -rf "$DRUPAL_CONFIGURATION_DIR/*.yml"
$DRUSH config-export --destination="$DRUPAL_CONFIGURATION_DIR"
