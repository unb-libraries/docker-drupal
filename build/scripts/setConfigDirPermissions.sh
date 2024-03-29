#!/usr/bin/env sh
if [ "$DEPLOY_ENV" = "local" ] && [ -n "$LOCAL_USER_GROUP" ]; then
  find "$DRUPAL_CONFIGURATION_DIR" \! -user "$NGINX_RUN_USER" \! -group "$LOCAL_USER_GROUP" -print0 | xargs -r0 chown "$NGINX_RUN_USER":"$LOCAL_USER_GROUP" --
  chown "$NGINX_RUN_USER":"$LOCAL_USER_GROUP" "$DRUPAL_CONFIGURATION_DIR"
else
  find "$DRUPAL_CONFIGURATION_DIR" \! -user "$NGINX_RUN_USER" \! -group "$NGINX_RUN_GROUP" -print0 | xargs -r0 chown "$NGINX_RUN_USER":"$NGINX_RUN_GROUP" --
  chown "$NGINX_RUN_USER":"$NGINX_RUN_GROUP" "$DRUPAL_CONFIGURATION_DIR"
fi
