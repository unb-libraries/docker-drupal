#!/usr/bin/env sh
if [ "$DRUPAL_TESTING_TOOLS" != "FALSE" ]; then
  # Behat.
  cd ${DRUPAL_TESTING_ROOT}/behat
  composer install --prefer-dist
  ./vendor/bin/behat --init
  rm -rf ~/.composer/cache
fi
