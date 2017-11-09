#!/usr/bin/env sh
if [ "$DEPLOY_ENV" == "local" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes en devel field_ui views_ui
  mkdir -p ${DRUPAL_BUILD_TMPROOT}/modules/contrib

  # Enable Drupal Console
  cd ${DRUPAL_BUILD_TMPROOT}
  drupal init -n

elif [ "$DEPLOY_ENV" == "prod" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes pm-uninstall devel field_ui views_ui dblog
fi
