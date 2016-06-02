#!/usr/bin/env sh
drush --root=${DRUPAL_ROOT} --uri=default --yes config-import --source=/app/configuration
