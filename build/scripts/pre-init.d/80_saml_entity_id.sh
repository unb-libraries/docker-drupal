#!/usr/bin/env sh
SAMLAUTH=$($DRUSH pml --no-core --status=Enabled --format=list|grep samlauth)
if [ "$DEPLOY_ENV" == "dev" ] && [ "$SAMLAUTH" == "samlauth" ]; then
  ${DRUSH} cset samlauth.authentication sp_entity_id "https://dev-${DRUPAL_SITE_URI}"
fi
