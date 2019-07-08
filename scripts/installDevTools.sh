#!/usr/bin/env sh

# Dev/NoDev
DRUPAL_COMPOSER_DEV="${1:-no-dev}"

# Dev Addons.
if [ "$DRUPAL_COMPOSER_DEV" == "dev" ]; then
  # Copy default services if no services.yml has been provided
  if [[ ! -f "${DRUPAL_BUILD_TMPROOT}/sites/default/services.yml" ]]; then
    cp "${DRUPAL_BUILD_TMPROOT}/sites/default/default.services.yml" "${DRUPAL_BUILD_TMPROOT}/sites/default/services.yml"
  fi

  # Twig settings
  sed -i "s|debug: false|debug: true|g" ${DRUPAL_BUILD_TMPROOT}/sites/default/services.yml
  sed -i "s|cache: true|cache: false|g" ${DRUPAL_BUILD_TMPROOT}/sites/default/services.yml
fi
