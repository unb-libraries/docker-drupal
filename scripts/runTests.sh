#!/usr/bin/env sh
set -e

# Behat.
if [ -d "${DRUPAL_TESTING_ROOT}/behat" ]; then
  cd "${DRUPAL_TESTING_ROOT}/behat"
  if [ ! -e "./vendor/bin/behat" ]; then
    echo "Installing behat testing tools..."
    composer install --prefer-dist
  fi
  ./vendor/bin/behat
fi

# PHPunit.
EXEC_DRUSH="drush --yes --root=/app/html --uri=default"
$EXEC_DRUSH en simpletest
for CUR_TEST_CLASS in $DRUPAL_UNIT_TEST_CLASSES
do
   su nginx -s /bin/sh -c "php /app/html/core/scripts/run-tests.sh --url http://127.0.0.1 --php /usr/bin/php --die-on-fail --class '$CUR_TEST_CLASS'"
done
$EXEC_DRUSH pm-uninstall simpletest
