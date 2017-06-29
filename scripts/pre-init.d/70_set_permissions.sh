#!/usr/bin/env sh
# Prevent web daemon from modifying drupal tree files.
find ${DRUPAL_ROOT} -not -path "${DRUPAL_ROOT}/sites/default/*" -exec chown root:root {} \;

# Make sure local development sets file permissions.
if [ "$DEPLOY_ENV" == "local" ]; then
  chown ${NGINX_RUN_USER}:${NGINX_RUN_GROUP} -R ${DRUPAL_ROOT}/sites/default/files
fi

# Prevent web daemon from changing files .htaccess
chown root:root ${DRUPAL_ROOT}/sites/default/files/.htaccess

# Set config sync perms.
chown ${NGINX_RUN_USER}:${NGINX_RUN_GROUP} -R ${DRUPAL_ROOT}/config/sync
