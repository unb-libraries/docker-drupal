#!/usr/bin/env sh
if [ "$DEPLOY_ENV" == "local" ]; then
  echo "Ensuring some modules are enabled for local development..."
  ${DRUSH} en devel field_ui views_ui
  mkdir -p ${DRUPAL_ROOT}/modules/contrib

  # Enable Drupal Console
  cd ${DRUPAL_ROOT}
  echo "Enabling Drupal console..."
  drupal --quiet init -n

elif [ "$DEPLOY_ENV" == "prod" ]; then
  echo "Ensuring some modules are disabled in production..."
  ${DRUSH} pm-uninstall devel field_ui views_ui dblog  > /dev/null 2>&1
fi
