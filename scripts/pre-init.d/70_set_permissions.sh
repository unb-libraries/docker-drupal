#!/usr/bin/env sh
# Prevent web daemon from modifying drupal tree files.
find ${DRUPAL_ROOT} -not -path "${DRUPAL_ROOT}/sites/default/*" -exec chown root:root {} \;

# Prevent web daemon from changing files .htaccess
chown root:root ${DRUPAL_ROOT}/sites/default/files/.htaccess
