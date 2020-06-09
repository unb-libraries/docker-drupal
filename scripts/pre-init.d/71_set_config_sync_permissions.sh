#!/usr/bin/env sh
# Allow the web daemon user to write to the config sync directory.
find ${DRUPAL_ROOT}/config/sync \! -user ${NGINX_RUN_USER} \! -group ${NGINX_RUN_GROUP} -print0 | xargs -0 chown ${NGINX_RUN_USER}:${NGINX_RUN_USER} --
