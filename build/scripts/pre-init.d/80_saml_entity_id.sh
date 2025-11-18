#!/usr/bin/env sh
if ! grep -q samlauth "$DRUPAL_CONFIGURATION_DIR/core.extension.yml"; then
  echo "SAMLAuth module not enabled, skipping dev SAML re-configuration."
  exit 0
fi

if [ "$DEPLOY_ENV" = "dev" ]; then
  $DRUSH config-get samlauth.authentication 1> /dev/null 2> /dev/null && $DRUSH cset samlauth.authentication sp_entity_id "https://dev-$DRUPAL_SITE_URI"
fi
