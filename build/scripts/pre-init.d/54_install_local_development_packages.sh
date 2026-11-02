#!/usr/bin/env sh
# Install composer dev packages before drush first bootstraps, so a local
# database that already has devel enabled can find its code.
if [ "$DEPLOY_ENV" = "local" ]; then
  echo "Local environment detected, installing development packages..."
  cd "$DRUPAL_ROOT"
  ${COMPOSER_INSTALL}
fi
