#!/usr/bin/env sh
if [ -n "$DEPLOY_ENV" ] && [ -n "$NR_INSTALL_KEY" ] && [ ! "$DEPLOY_ENV" = "local" ]; then
  sed -i "s|newrelic.appname = \"PHP Application\"|newrelic.appname = \"$DEPLOY_ENV:$DRUPAL_SITE_URI\"|g" "$PHP_CONFD_DIR/newrelic.ini"
  sed -i "s|REPLACE_WITH_REAL_KEY|$NR_INSTALL_KEY|g" "$PHP_CONFD_DIR/newrelic.ini"
  echo "newrelic.labels = \"Environment:$DEPLOY_ENV;Node:$KUBERNETES_SERVICE_HOST;Framework:Drupal\"" >> "$PHP_CONFD_DIR/newrelic.ini"
fi
