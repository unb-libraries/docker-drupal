#!/usr/bin/env sh
if [[ -z "$1" ]]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes --no-browser user:login
else
  drush --root=${DRUPAL_ROOT} --uri=default --yes --no-browser user:login --name="$1"
fi
