#!/usr/bin/env sh
if [ "$DRUPAL_SITE_UUID" != "FALSE" ]; then
  ${DRUSH} cset system.site uuid ${DRUPAL_SITE_UUID}
  /scripts/clearDrupalCache.sh
fi
