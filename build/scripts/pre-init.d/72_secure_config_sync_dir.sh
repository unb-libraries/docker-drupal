#!/usr/bin/env sh
# Add a .htaccess file that denies execution to satisfy Drupal.
cp /security_htaccess/.htaccess.PreventExecution "$DRUPAL_CONFIGURATION_DIR/.htaccess"
chown root:root "$DRUPAL_CONFIGURATION_DIR/.htaccess"
