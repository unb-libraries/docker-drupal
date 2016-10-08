#!/usr/bin/env sh
if [ "$DEPLOY_ENV" = "local" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes en devel field_ui views_ui
  mkdir -p ${DRUSH_MAKE_TMPROOT}/modules/contrib
elif [ "$DEPLOY_ENV" = "prod" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes pm-uninstall devel field_ui views_ui dblog
fi
