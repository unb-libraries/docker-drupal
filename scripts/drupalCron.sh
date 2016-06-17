#!/usr/bin/env sh
su nginx -s /bin/sh -c 'DRUSH_PHP=/usr/bin/php drush --root=${DRUPAL_ROOT} --uri=default --yes core-cron'
