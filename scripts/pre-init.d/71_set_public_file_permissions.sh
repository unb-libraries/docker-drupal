#!/usr/bin/env sh
find ${DRUPAL_ROOT}/sites/default/files \! -user ${NGINX_RUN_USER} \! -group ${NGINX_RUN_GROUP} -print0 | xargs -r0 chown ${NGINX_RUN_USER}:${NGINX_RUN_GROUP} --

# Exception : prevent the web daemon user from changing files directory .htaccess
chown root:root ${DRUPAL_ROOT}/sites/default/files/.htaccess
