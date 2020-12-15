#!/usr/bin/env sh
rm -rf ${DRUPAL_CONFIGURATION_DIR}/*
chown ${NGINX_RUN_USER}:${NGINX_RUN_GROUP} ${DRUPAL_CONFIGURATION_DIR}
${DRUSH} config-export --skip-modules=${DRUPAL_CONFIGURATION_EXPORT_SKIP} --destination=${DRUPAL_CONFIGURATION_DIR}