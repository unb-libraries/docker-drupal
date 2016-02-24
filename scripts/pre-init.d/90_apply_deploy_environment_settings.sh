#!/usr/bin/env sh
if [ "$DEPLOY_ENV" = "dev" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes en devel field_ui views_ui
  rsync -a --progress --no-perms --no-owner --no-group ${DRUPAL_ROOT}/modules/devel ${DRUSH_MAKE_TMPROOT}/modules
elif [ "$DEPLOY_ENV" = "prod" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes pm-uninstall devel field_ui views_ui dblog
fi
