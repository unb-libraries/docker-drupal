#!/usr/bin/env sh
if [ "$DEPLOY_ENV" == "local" ]; then
  echo "Local environment detected, installing and enabling development modules..."

  # Install composer dev packages.
  cd ${DRUPAL_ROOT}
  ${COMPOSER_INSTALL}
  ${DRUSH} en devel

  # Set dev container settings.
  yq w -i /app/html/sites/default/services.yml parameters.[http.response.debug_cacheability_headers] true
  yq w -i /app/html/sites/default/services.yml parameters.[twig.config].auto_reload true
  yq w -i /app/html/sites/default/services.yml parameters.[twig.config].auto_debug true
  yq w -i /app/html/sites/default/services.yml parameters.[twig.config].auto_cache false

  # Make sure caching is disabled.
  echo "\$settings['cache']['bins']['render'] = 'cache.backend.null';" >> ${DRUPAL_ROOT}/sites/all/settings/settings.local.inc
  echo "\$settings['cache']['bins']['dynamic_page_cache'] = 'cache.backend.null';" >> ${DRUPAL_ROOT}/sites/all/settings/settings.local.inc
fi
