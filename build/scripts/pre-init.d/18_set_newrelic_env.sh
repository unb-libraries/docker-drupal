#!/usr/bin/env sh
if [ "$ENABLE_NEWRELIC" = "true" ] && [ -n "$NR_INSTALL_KEY" ]; then
  echo "Configuring New Relic..."
  sed -i "s|newrelic.appname = \"PHP Application\"|newrelic.appname = \"$DEPLOY_ENV:$DRUPAL_SITE_URI\"|g" "$PHP_CONFD_DIR/newrelic.ini"
  sed -i "s|REPLACE_WITH_REAL_KEY|$NR_INSTALL_KEY|g" "$PHP_CONFD_DIR/newrelic.ini"
  echo "newrelic.labels = \"Environment:$DEPLOY_ENV;Node:$KUBERNETES_SERVICE_HOST;Framework:Drupal\"" >> "$PHP_CONFD_DIR/newrelic.ini"
  echo "newrelic.distributed_tracing_enabled = true" >> "$PHP_CONFD_DIR/newrelic.ini"
else
  echo "New Relic not enabled or NR_INSTALL_KEY not set. Skipping configuration..."
  rm -f "$PHP_CONFD_DIR/newrelic.ini"
fi
