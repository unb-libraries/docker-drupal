#!/usr/bin/env bash

if [ "$DRUPAL_REVERT_FEATURES" == "TRUE" ]; then
  /sbin/setuser www-data drush --root=${DRUPAL_ROOT} --uri=default --yes fra
fi;
