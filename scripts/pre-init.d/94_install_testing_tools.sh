#!/usr/bin/env sh
if [ "$DRUPAL_TESTING_TOOLS" != "FALSE" ]; then
  cd ${DRUPAL_TESTING_ROOT}
  composer install --prefer-dist
  ./vendor/bin/behat --init
fi
