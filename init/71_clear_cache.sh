#!/usr/bin/env bash

cd ${DRUPAL_ROOT}
/sbin/setuser www-data drush --yes cc all

