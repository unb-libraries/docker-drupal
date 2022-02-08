#!/usr/bin/env sh
set -e

if [ ! -e "$DRUPAL_ROOT/vendor/bin/phpunit" ]; then
  echo "Installing PHPUnit testing tools..."
  cd "$DRUPAL_ROOT"
  ${COMPOSER_INSTALL}
fi

# PHPUnit Tests
for CUR_TEST_MODULE in $DRUPAL_UNIT_TEST_MODULES
do
  su nginx -s /bin/sh -c "php /app/html/core/scripts/run-tests.sh --php /usr/bin/php --module $CUR_TEST_MODULE"
done
