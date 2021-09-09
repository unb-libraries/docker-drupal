#!/usr/bin/env sh
if [ "$DEPLOY_ENV" == "dev" ]; then
  $DRUSH config-get samlauth.authentication  1> /dev/null 2> /dev/null && ${DRUSH} cset samlauth.authentication sp_entity_id "https://dev-${DRUPAL_SITE_URI}"
fi
