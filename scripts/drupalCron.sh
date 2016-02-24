#!/usr/bin/env sh
su apache -s /bin/sh -c 'drush --root=${DRUPAL_ROOT} --uri=default --yes core-cron'
