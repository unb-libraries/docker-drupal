#!/usr/bin/env sh
if [ "$DEPLOY_ENV" = "dev" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes en devel field_ui views_ui
elif [ "$DEPLOY_ENV" = "prod" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes dis devel field_ui views_ui dblog
fi
