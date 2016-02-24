#!/usr/bin/env sh
su nginx -s /bin/sh -c 'drush --root=${DRUPAL_ROOT} --uri=default --yes core-cron'
