#!/usr/bin/env bash

/sbin/setuser www-data drush --root=${DRUPAL_ROOT} --uri=default --yes cc all
