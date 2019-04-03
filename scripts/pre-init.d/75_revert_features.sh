#!/usr/bin/env sh
if [ "$DRUPAL_REVERT_FEATURES" == "TRUE" ]; then
  ${DRUSH} fra
  ${DRUSH} cache-rebuild
fi;
