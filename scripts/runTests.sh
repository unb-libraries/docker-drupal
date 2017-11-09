#!/usr/bin/env sh

# Behat.
cd "${DRUPAL_TESTING_ROOT}/behat"

# If we have mounted in the test dir as a volume, the vendor may have been overwritten.
if [ ! -e "./vendor/bin/behat" ]; then
  echo "File does not exist"
  composer install
fi 

./vendor/bin/behat
