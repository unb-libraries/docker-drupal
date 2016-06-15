#!/usr/bin/env sh
if [ "$DRUPAL_TESTING_TOOLS" != "FALSE" ]; then
  cd ${DRUPAL_ROOT}
  /usr/local/bin/composer require drupal/drupal-extension='~3.0' --prefer-dist
  ln -s ${TMP_DRUPAL_BUILD_DIR}/behat.yml ${DRUPAL_ROOT}/
  ln -s ${TMP_DRUPAL_BUILD_DIR}/features ${DRUPAL_ROOT}/features
  ./vendor/bin/behat --init
fi
