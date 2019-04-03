#!/usr/bin/env sh
if [ "$DEPLOY_ENV" == "local" ]; then
  ${DRUSH} en devel field_ui views_ui
  mkdir -p ${DRUPAL_BUILD_TMPROOT}/modules/contrib

  # Enable Drupal Console
  cd ${DRUPAL_BUILD_TMPROOT}
  drupal init -n

elif [ "$DEPLOY_ENV" == "prod" ]; then
  ${DRUSH} pm-uninstall devel field_ui views_ui dblog  > /dev/null 2>&1
fi
