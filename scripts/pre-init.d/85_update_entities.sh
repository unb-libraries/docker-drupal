#!/usr/bin/env sh
drush --root=${DRUPAL_ROOT} --uri=default --yes entity-updates
drush --root=${DRUPAL_ROOT} --uri=default --yes cache-rebuild
