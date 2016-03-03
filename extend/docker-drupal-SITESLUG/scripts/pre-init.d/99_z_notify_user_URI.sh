#!/usr/bin/env sh
if [ -n "$DEV_WEB_URI" ]; then
  echo "Visit your instance at:"
  echo "$DEV_WEB_URI"
  echo "Log-in to your instance via:"
  drush --root=${DRUPAL_ROOT} --uri=default --yes uli | sed -e "s|http://default|$DEV_WEB_URI|g"
fi
