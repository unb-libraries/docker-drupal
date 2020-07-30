#!/usr/bin/env sh

# Clear composer cache.
if [ "$COMPOSER_CLEAR_CACHE" != "FALSE" ]; then
  composer clear-cache
fi

# Remove build dir.
rm -rf /build

# Remove source package conf.
rm -rf /package-conf
