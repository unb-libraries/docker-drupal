#!/usr/bin/env sh
if [ -n "$DRUPAL_PRIVATE_FILE_PATH" ]; then
  mkdir -p "$DRUPAL_PRIVATE_FILE_PATH" && chown "$NGINX_RUN_USER:$NGINX_RUN_GROUP" "$DRUPAL_PRIVATE_FILE_PATH"
fi
