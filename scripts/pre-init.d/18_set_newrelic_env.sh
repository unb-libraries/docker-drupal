#!/usr/bin/env sh
if [ -n "$DEPLOY_ENV" ] && [ -n "$NR_INSTALL_KEY" ] && [ ! "$DEPLOY_ENV" = "local" ]; then
  sed -i "s|newrelic.appname = \"PHP Application\"|newrelic.appname = \"${DRUPAL_SITE_URI};${DEPLOY_ENV};${DRUPAL_SITE_URI}_${DEPLOY_ENV}\"|g" /etc/php7/conf.d/newrelic.ini
  sed -i "s|REPLACE_WITH_REAL_KEY|${NR_INSTALL_KEY}|g" /etc/php7/conf.d/newrelic.ini
fi
