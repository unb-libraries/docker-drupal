#!/usr/bin/env sh
# Set-up secure permissions.
chown root:root -R ${DRUPAL_ROOT}
chown ${NGINX_RUN_USER}:${NGINX_RUN_GROUP} -R ${DRUPAL_ROOT}/sites/default/files
chown root:root ${DRUPAL_ROOT}/sites/default/files/.htaccess
