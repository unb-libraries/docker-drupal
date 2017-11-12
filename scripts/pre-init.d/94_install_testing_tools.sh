#!/usr/bin/env sh
if [ "$DRUPAL_TESTING_TOOLS" != "FALSE" ]; then
  cd ${DRUPAL_TESTING_ROOT}/behat

  # Avoid case where user mounts testing in compose and nukes vendor.
  if [ ! -f ./vendor/bin/behat ]; then
    echo "Installing behat testing libraries"
    composer install --prefer-dist --no-interaction --dev
  fi

  # Behat needs a functional drupal install to init.
  ./vendor/bin/behat --init
fi
