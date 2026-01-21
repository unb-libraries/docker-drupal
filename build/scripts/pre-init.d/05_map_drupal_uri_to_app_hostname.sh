#!/usr/bin/env sh
set -eu

# If DRUPAL_SITE_URI exists and APP_HOSTNAME is not already set,
# map DRUPAL_SITE_URI -> APP_HOSTNAME.
if [ -n "${DRUPAL_SITE_URI:-}" ] && [ -z "${APP_HOSTNAME:-}" ]; then
  export APP_HOSTNAME="$DRUPAL_SITE_URI"
fi
