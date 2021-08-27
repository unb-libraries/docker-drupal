#!/usr/bin/env sh
# Instances with massive filesystems can choke on this command.
if [ "$DRUPAL_CHOWN_PUBLIC_FILES_STARTUP" = "TRUE" ] || [ "$DEPLOY_ENV" == "local" ]; then
  find ${DRUPAL_ROOT}/sites/default/files \! -user ${NGINX_RUN_USER} \! -group ${NGINX_RUN_GROUP} -print0 | xargs -r0 chown ${NGINX_RUN_USER}:${NGINX_RUN_GROUP} --
fi

# Make sure the config sync dir is writable by the webserver.
chown ${NGINX_RUN_USER}:${NGINX_RUN_GROUP} "$DRUPAL_CONFIGURATION_DIR"

# Exception : prevent the web daemon user from changing files directory .htaccess
chown root:root ${DRUPAL_ROOT}/sites/default/files/.htaccess
