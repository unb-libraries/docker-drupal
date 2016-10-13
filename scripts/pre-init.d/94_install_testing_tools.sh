#!/usr/bin/env sh
if [ "$DRUPAL_TESTING_TOOLS" != "FALSE" ]; then
  cd ${DRUPAL_ROOT}
  ln -s ${TMP_DRUPAL_BUILD_DIR}/behat.yml ${DRUPAL_ROOT}/
  ln -s ${TMP_DRUPAL_BUILD_DIR}/features ${DRUPAL_ROOT}/features
  ./vendor/bin/behat --init
  chmod -R g+w features/
fi
