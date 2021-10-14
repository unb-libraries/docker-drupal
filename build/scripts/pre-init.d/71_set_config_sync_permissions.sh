#!/usr/bin/env sh
# Allow the web daemon user to write to the config sync directory.
find ${DRUPAL_CONFIGURATION_DIR} \! -user ${NGINX_RUN_USER} \! -group ${NGINX_RUN_GROUP} -print0 | xargs -r0 chown ${NGINX_RUN_USER}:${NGINX_RUN_GROUP} --

# Add a .htaccess file that denies execution to satisfy Drupal.
cp /security_htaccess/.htaccess.PreventExecution ${DRUPAL_CONFIGURATION_DIR}/.htaccess.PreventExecution
chown root:root ${DRUPAL_CONFIGURATION_DIR}/.htaccess.PreventExecution
