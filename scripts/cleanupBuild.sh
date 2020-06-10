#!/usr/bin/env sh
# Dev/NoDev
DRUPAL_COMPOSER_DEV="${1:-no-dev}"

# Remove testing, etc if not dev.
if [ "$DRUPAL_COMPOSER_DEV" != "dev" ]; then
  rm -rf $DRUPAL_TESTING_ROOT
fi

# Clear composer cache.
if [ "$COMPOSER_CLEAR_CACHE" != "FALSE" ]; then
  composer clear-cache
fi

# Remove build dir.
rm -rf /build

# Remove source package conf.
rm -rf /package-conf
