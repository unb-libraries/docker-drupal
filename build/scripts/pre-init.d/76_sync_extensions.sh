#!/usr/bin/env sh
# Synchronize Drupal extensions before configuration import.

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
