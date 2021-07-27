#!/usr/bin/env sh
if [ "$DEPLOY_ENV" == "local" ]; then
  echo "Local environment detected, installing and enabling development modules..."

  # Set dev container settings in scaffold files.
  yq w -i ${DRUPAL_ROOT}/core/assets/scaffold/files/development.services.yml parameters.[http.response.debug_cacheability_headers] true
  yq w -i ${DRUPAL_ROOT}/core/assets/scaffold/files/development.services.yml parameters.[twig.config].auto_reload true
  yq w -i ${DRUPAL_ROOT}/core/assets/scaffold/files/development.services.yml parameters.[twig.config].debug true
  yq w -i ${DRUPAL_ROOT}/core/assets/scaffold/files/development.services.yml parameters.[twig.config].cache false
  cp ${DRUPAL_ROOT}/core/assets/scaffold/files/development.services.yml ${DRUPAL_ROOT}/sites/development.services.yml

  # Install composer dev packages.
  cd ${DRUPAL_ROOT}

  # This composer install command also copies scaffold development.services.yml.
  ${COMPOSER_INSTALL}

  # Enable devel.
  ${DRUSH} en devel

  # Make sure caching is disabled.
  echo "\$settings['cache']['bins']['render'] = 'cache.backend.null';" >> ${DRUPAL_ROOT}/sites/all/settings/settings.local.inc
  echo "\$settings['cache']['bins']['dynamic_page_cache'] = 'cache.backend.null';" >> ${DRUPAL_ROOT}/sites/all/settings/settings.local.inc
fi
