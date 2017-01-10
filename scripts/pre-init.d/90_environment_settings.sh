#!/usr/bin/env sh
if [ "$DEPLOY_ENV" == "local" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes en devel field_ui views_ui
  mkdir -p ${DRUPAL_BUILD_TMPROOT}/modules/contrib

  # Enable Drupal Console
  cd ${DRUPAL_ROOT}
  drupal init -n

  # Copy default services
  cp ${DRUPAL_ROOT}/sites/default/default.services.yml ${DRUPAL_ROOT}/sites/default/services.yml

  # Twig settings
  sed -i "s|debug: false|debug: true|g" ${DRUPAL_ROOT}/sites/default/services.yml
  sed -i "s|cache: true|cache: false|g" ${DRUPAL_ROOT}/sites/default/services.yml
elif [ "$DEPLOY_ENV" == "prod" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes pm-uninstall devel field_ui views_ui dblog
fi
