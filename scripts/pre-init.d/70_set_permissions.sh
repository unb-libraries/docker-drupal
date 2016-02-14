#!/usr/bin/env bash

# Set-up secure permissions.
chown root:root -R ${DRUPAL_ROOT}
chown ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} -R ${DRUPAL_ROOT}/sites/default/files
chown root:root ${DRUPAL_ROOT}/sites/default/files/.htaccess
