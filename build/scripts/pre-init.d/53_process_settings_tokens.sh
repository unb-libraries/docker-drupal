#!/usr/bin/env sh
find ${DRUPAL_ROOT}/sites/all/settings -type f \( -name "*.php" -o -name "*.inc" \) -exec sed -i "s|DRUPAL_SITE_ID|$DRUPAL_SITE_ID|g" {} \;
