#!/usr/bin/env sh
if [ "$DRUPAL_TESTING_TOOLS" != "FALSE" ]; then
  # Behat needs a functional drupal install to init.
  cd ${DRUPAL_TESTING_ROOT}/behat
  ./vendor/bin/behat --init
fi
