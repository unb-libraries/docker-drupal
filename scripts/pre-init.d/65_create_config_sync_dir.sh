#!/usr/bin/env sh
# Ensure the configuration sync directory exists, and is permissioned.
mkdir -p ${DRUPAL_ROOT}/config/sync
chown ${NGINX_RUN_USER}:${NGINX_RUN_GROUP} -R ${DRUPAL_ROOT}/config/sync
