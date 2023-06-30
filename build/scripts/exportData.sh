#!/usr/bin/env sh
set -e

# Set up path location.
HASH=$(echo $RANDOM | md5sum | head -c 20; echo)
BASE_PATH='/data-export'
EXPORT_PATH="$BASE_PATH/$HASH"
rm -rf "$EXPORT_PATH"
mkdir -p "$EXPORT_PATH"
chown $NGINX_RUN_USER:$NGINX_RUN_GROUP $EXPORT_PATH

# Export Content
/scripts/exportContent.sh "$EXPORT_PATH"
/scripts/exportFiles.sh "$EXPORT_PATH"
