#!/usr/bin/env sh
# Make sure the config sync dir is writable by the webserver.
chown ${NGINX_RUN_USER}:${NGINX_RUN_GROUP} "$DRUPAL_CONFIGURATION_DIR"

# Add a .htaccess file that denies execution to satisfy Drupal.
cp /security_htaccess/.htaccess.PreventExecution ${DRUPAL_CONFIGURATION_DIR}/.htaccess
chown root:root ${DRUPAL_CONFIGURATION_DIR}/.htaccess
