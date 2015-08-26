#!/usr/bin/env bash

# Set-up secure permissions.
chown root:root -R ${DRUPAL_ROOT}
chown ${WEBSERVER_USER_ID}:${WEBSERVER_USER_ID} -R ${DRUPAL_ROOT}/sites/default/files
chown root:root ${DRUPAL_ROOT}/sites/default/files/.htaccess
