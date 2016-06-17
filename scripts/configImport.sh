#!/usr/bin/env sh
drush --root=${DRUPAL_ROOT} --uri=default --yes config-import --source=${DRUPAL_CONFIGURATION_DIR}
