#!/usr/bin/env sh
if [ "$DRUPAL_TESTING_TOOLS" != "FALSE" ]; then
  cd ${DRUPAL_TESTING_ROOT}/behat

  # Behat needs a functional drupal install to init.
  ./vendor/bin/behat --init
fi
