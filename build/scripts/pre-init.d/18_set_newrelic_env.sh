#!/usr/bin/env sh
if [ "$ENABLE_NEWRELIC" = "true" ] && [ -n "$NR_INSTALL_KEY" ]; then
  echo "Enabling New Relic..."
  sed -i "s|newrelic.appname = \"PHP Application\"|newrelic.appname = \"$DEPLOY_ENV:$DRUPAL_SITE_URI\"|g" "$PHP_CONFD_DIR/newrelic.ini"
  sed -i "s|REPLACE_WITH_REAL_KEY|$NR_INSTALL_KEY|g" "$PHP_CONFD_DIR/newrelic.ini"
  echo "newrelic.labels = \"Environment:$DEPLOY_ENV;Node:$KUBERNETES_SERVICE_HOST;Framework:Drupal\"" >> "$PHP_CONFD_DIR/newrelic.ini"
  if [ "$ENABLE_NEWRELIC_TRACING" = "true" ]; then
    cat <<EOF >> "$PHP_CONFD_DIR/newrelic.ini"
newrelic.distributed_tracing_enabled = true
newrelic.transaction_tracer.enabled = true
newrelic.transaction_tracer.threshold = "200ms"
newrelic.transaction_tracer.record_sql = "raw"
newrelic.transaction_tracer.stack_trace_threshold = "200ms"
newrelic.transaction_tracer.slow_sql = true
newrelic.transaction_tracer.explain_enabled = true
newrelic.transaction_tracer.explain_threshold = "200ms"
EOF
  fi
else
  echo "New Relic not enabled or NR_INSTALL_KEY not set. Skipping configuration..."
  rm -f "$PHP_CONFD_DIR/newrelic.ini"
fi
