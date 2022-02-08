#!/usr/bin/env sh
set -e

# Behat.
if [ -d "$DRUPAL_TESTING_ROOT/behat" ]; then
  cd "$DRUPAL_TESTING_ROOT/behat"
  if [ ! -e "./vendor/bin/behat" ]; then
    echo "Installing behat testing tools..."
    composer install --prefer-dist
  fi

  ./vendor/bin/behat
fi
