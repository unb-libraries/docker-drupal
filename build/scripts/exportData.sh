#!/usr/bin/env sh
set -e

if [ $# -ne 1 ];then
  echo "No target location specified, generating random location."
  HASH=$(echo $RANDOM | md5sum | head -c 20; echo)
  BASE_PATH='/data-export'
  EXPORT_PATH="$BASE_PATH/$HASH"
  mkdir -p "$EXPORT_PATH"
  chown $NGINX_RUN_USER:$NGINX_RUN_GROUP $EXPORT_PATH
else
  EXPORT_PATH="$1"
fi

# Export Content
/scripts/exportContent.sh "$EXPORT_PATH"
/scripts/exportFiles.sh "$EXPORT_PATH"
