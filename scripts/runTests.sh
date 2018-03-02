#!/usr/bin/env sh

# Behat.
cd "${DRUPAL_TESTING_ROOT}/behat"

# If we have mounted in the test dir as a volume, the vendor may have been overwritten.
if [ ! -e "./vendor/bin/behat" ]; then
  echo "File does not exist"
  composer install
fi

./vendor/bin/behat

# PHP unit tests
set -e
EXEC_DRUSH="drush --yes --root=/app/html --uri=default"

$EXEC_DRUSH en simpletest
for CUR_TEST_CLASS in $DRUPAL_UNIT_TEST_CLASSES
do
   su nginx -s /bin/sh -c "php /app/html/core/scripts/run-tests.sh --url http://127.0.0.1 --php /usr/bin/php --die-on-fail --class '$CUR_TEST_CLASS'"
done
$EXEC_DRUSH pm-uninstall simpletest
