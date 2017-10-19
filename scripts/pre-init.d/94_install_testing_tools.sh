#!/usr/bin/env sh
if [ "$DRUPAL_TESTING_TOOLS" != "FALSE" ]; then
  cd ${DRUPAL_BEHAT_TESTING_ROOT}
  composer install --prefer-dist
  ./vendor/bin/behat --init
  chmod -R g+w ${DRUPAL_BEHAT_TESTING_ROOT}
fi
