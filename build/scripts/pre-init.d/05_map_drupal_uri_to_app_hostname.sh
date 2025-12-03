#!/bin/sh
set -eu

# If SITE_URI exists and APP_HOSTNAME is not already set,
# map SITE_URI -> APP_HOSTNAME.
if [ -n "${SITE_URI:-}" ] && [ -z "${APP_HOSTNAME:-}" ]; then
  export APP_HOSTNAME="$SITE_URI"
fi

