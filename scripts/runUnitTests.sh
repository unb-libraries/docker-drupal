#!/usr/bin/env sh
set -e

# PHPUnit Tests
for CUR_TEST_MODULE in $DRUPAL_UNIT_TEST_MODULES
do
  # If we've enabled redis for locks, etc, tests fail. Temporarily disable it.
  if [ -f "$DRUPAL_ROOT/modules/contrib/redis/example.services.yml" ]; then
    mv "$DRUPAL_ROOT/modules/contrib/redis/example.services.yml" "$DRUPAL_ROOT/modules/contrib/redis/example.services.yml.disabled"
  fi

  $DRUSH en simpletest
  su nginx -s /bin/sh -c "php $DRUPAL_ROOT/core/scripts/run-tests.sh --php /usr/bin/php --module $CUR_TEST_MODULE"
  $DRUSH pmu simpletest

  if [ -f "$DRUPAL_ROOT/modules/contrib/redis/example.services.yml.disabled" ]; then
    mv "$DRUPAL_ROOT/modules/contrib/redis/example.services.yml.disabled" "$DRUPAL_ROOT/modules/contrib/redis/example.services.yml"
  fi
done
