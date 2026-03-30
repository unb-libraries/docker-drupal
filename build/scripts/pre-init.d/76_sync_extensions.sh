#!/usr/bin/env sh
# Synchronize Drupal extensions before configuration import.

# Skip on fresh installs - config import will handle everything.
if [ ! -f /tmp/DRUPAL_DB_LIVE ] && [ ! -f /tmp/DRUPAL_FILES_LIVE ]; then
  echo "Sync Extensions : Fresh install detected, skipping (config import will handle)."
  exit 0
fi

# Skip if no configuration directory exists or is empty
if [ ! -d "$DRUPAL_CONFIGURATION_DIR" ] || [ -z "$(ls $DRUPAL_CONFIGURATION_DIR 2>/dev/null)" ]; then
  echo "Sync Extensions : No configuration directory found, skipping."
  exit 0
fi

CORE_EXTENSION_FILE="$DRUPAL_CONFIGURATION_DIR/core.extension.yml"
if [ ! -f "$CORE_EXTENSION_FILE" ]; then
  echo "Sync Extensions : core.extension.yml not found, skipping."
  exit 0
fi

/scripts/syncExtensions.sh
