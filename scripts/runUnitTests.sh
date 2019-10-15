#!/usr/bin/env sh
set -e

# PHPUnit Tests
for CUR_TEST_MODULE in $DRUPAL_UNIT_TEST_MODULES
do
  su nginx -s /bin/sh -c "php /app/html/core/scripts/run-tests.sh --php /usr/bin/php --module $CUR_TEST_MODULE"
done
