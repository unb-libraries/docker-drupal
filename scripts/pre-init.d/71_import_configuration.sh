#!/usr/bin/env sh
# UUID
if [ "$DRUPAL_SITE_UUID" != "FALSE" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes cset system.site uuid ${DRUPAL_SITE_UUID}
fi

# Configuration
if [ "$DRUPAL_DEPLOY_CONFIGURATION" != "FALSE" ] && [ -d "$DRUPAL_CONFIGURATION_DIR" ] && [ "$(rm $DRUPAL_CONFIGURATION_DIR/.gitkeep)" ] && [ "$(ls -A $DRUPAL_CONFIGURATION_DIR)" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes ev '\Drupal::entityManager()->getStorage("shortcut_set")->load("default")->delete();'
  /scripts/configImport.sh
fi
