#!/usr/bin/env sh
if [ "$DRUPAL_REVERT_FEATURES" == "TRUE" ]; then
  ${DRUSH} fra
  /scripts/clearDrupalCache.sh
fi;
