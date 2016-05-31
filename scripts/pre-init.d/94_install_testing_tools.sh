#!/usr/bin/env sh
if [ "$DRUPAL_TESTING_TOOLS" != "FALSE" ]; then
  cd ${DRUPAL_ROOT}
  /usr/local/bin/composer require drupal/drupal-extension='~3.0'
  rsync -a --progress --no-perms --no-owner --no-group ${TMP_DRUPAL_BUILD_DIR}/behat.yml ${DRUPAL_ROOT}
  rsync -a --progress --no-perms --no-owner --no-group ${TMP_DRUPAL_BUILD_DIR}/features ${DRUPAL_ROOT}
  ./vendor/bin/behat --init
fi
