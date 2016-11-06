#!/usr/bin/env sh
if [ "$DEPLOY_ENV" == "local" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes en devel field_ui views_ui
  mkdir -p ${DRUPAL_BUILD_TMPROOT}/modules/contrib
  cd ${DRUPAL_ROOT}
  drupal init -n
  drupal site:mode dev
  sed -i "s|twig.config:.*|twig.config: { debug: true, auto_reload: null, cache: false }|g" ${DRUPAL_ROOT}/sites/default/services.yml
elif [ "$DEPLOY_ENV" == "prod" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes pm-uninstall devel field_ui views_ui dblog
fi
