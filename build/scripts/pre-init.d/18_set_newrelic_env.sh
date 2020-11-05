#!/usr/bin/env sh
if [ -n "$DEPLOY_ENV" ] && [ -n "$NR_INSTALL_KEY" ] && [ ! "$DEPLOY_ENV" = "local" ]; then
  if [ "$DEPLOY_ENV" = "dev" ]; then
      sed -i "s|newrelic.appname = \"PHP Application\"|newrelic.appname = \"dev-${DRUPAL_SITE_URI}\"|g" /etc/php7/conf.d/newrelic.ini
  fi
  if [ "$DEPLOY_ENV" = "prod" ]; then
      sed -i "s|newrelic.appname = \"PHP Application\"|newrelic.appname = \"${DRUPAL_SITE_URI}\"|g" /etc/php7/conf.d/newrelic.ini
  fi
  sed -i "s|REPLACE_WITH_REAL_KEY|${NR_INSTALL_KEY}|g" /etc/php7/conf.d/newrelic.ini
  echo "newrelic.labels = \"Environment:${DEPLOY_ENV};Node:${KUBERNETES_SERVICE_HOST};Framework:Drupal\"" >> /etc/php7/conf.d/newrelic.ini
fi
