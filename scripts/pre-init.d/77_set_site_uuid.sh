#!/usr/bin/env sh
if [ "$DRUPAL_SITE_UUID" != "FALSE" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes cset system.site uuid ${DRUPAL_SITE_UUID}
  drush --root=${DRUPAL_ROOT} --uri=default --yes cache-rebuild
fi
