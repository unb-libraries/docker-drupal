#!/usr/bin/env sh
rm -rf "$DRUPAL_CONFIGURATION_DIR/*.yml"
chown "$NGINX_RUN_USER":"$NGINX_RUN_GROUP" "$DRUPAL_CONFIGURATION_DIR"
$DRUSH config-export --destination="$DRUPAL_CONFIGURATION_DIR"
