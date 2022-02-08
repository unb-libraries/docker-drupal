#!/usr/bin/env sh
if [ "$DEPLOY_ENV" = "local" ]; then
  for LOCAL_EDITABLE_PATH in "$DRUPAL_ROOT/modules/custom" "$DRUPAL_ROOT/themes/custom" "$DRUPAL_TESTING_ROOT"
  do
    find "$LOCAL_EDITABLE_PATH" \! -group "$LOCAL_USER_GROUP" -print0 | xargs -r0 chgrp "$LOCAL_USER_GROUP" --
    find "$LOCAL_EDITABLE_PATH" \! -perm -g=w -print0 | xargs -r0 chmod g+w --
  done
fi
