#!/usr/bin/env sh
if [ "$DEPLOY_ENV" = "local" ]; then
  echo "Local environment detected, enabling development modules..."

  # Set dev container settings in scaffold files.
  yq -i eval '.parameters.http.response.debug_cacheability_headers = true' "$DRUPAL_ROOT/core/assets/scaffold/files/development.services.yml"
  yq -i eval '.parameters."twig.config".auto_reload = true' "$DRUPAL_ROOT/core/assets/scaffold/files/development.services.yml"
  yq -i eval '.parameters."twig.config".debug = true' "$DRUPAL_ROOT/core/assets/scaffold/files/development.services.yml"
  yq -i eval '.parameters."twig.config".cache = false' "$DRUPAL_ROOT/core/assets/scaffold/files/development.services.yml"
  cp "$DRUPAL_ROOT/core/assets/scaffold/files/development.services.yml" "$DRUPAL_ROOT/sites/development.services.yml"

  # Enable devel.
  ${DRUSH} en devel

  # Make sure caching is disabled.
  echo "\$settings['cache']['bins']['render'] = 'cache.backend.null';" >> "$DRUPAL_ROOT/sites/all/settings/settings.local.inc"
  echo "\$settings['cache']['bins']['dynamic_page_cache'] = 'cache.backend.null';" >> "$DRUPAL_ROOT/sites/all/settings/settings.local.inc"
fi
