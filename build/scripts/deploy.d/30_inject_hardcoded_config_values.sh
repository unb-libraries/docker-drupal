#!/usr/bin/env sh
/scripts/setSiteUuidFromEnv.sh

if [ -f "${DRUPAL_CONFIGURATION_DIR}/language.entity.en.yml" ]; then
  $DRUSH en language
  /scripts/setConfigValueFromExistingFiles.sh language.entity.en uuid
fi
