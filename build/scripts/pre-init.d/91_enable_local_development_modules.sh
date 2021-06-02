#!/usr/bin/env sh
if [ "$DEPLOY_ENV" == "local" ]; then
  echo "Local environment detected, installing and enabling development modules..."
  cd ${DRUPAL_ROOT}
  ${COMPOSER_INSTALL}
  ${DRUSH} en devel
fi
