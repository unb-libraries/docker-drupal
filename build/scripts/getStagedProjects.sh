#!/usr/bin/env sh
# Output list of projects from staged core.extension.yml (one per line)
# Usage: getStagedProjects.sh <module|theme>

TYPE="$1"
if [ "$TYPE" != "module" ] && [ "$TYPE" != "theme" ]; then
  echo "Usage: $0 <module|theme>" >&2
  exit 1
fi

CORE_EXTENSION_FILE="$DRUPAL_CONFIGURATION_DIR/core.extension.yml"
if [ -f "$CORE_EXTENSION_FILE" ]; then
  yq eval ".$TYPE | keys | .[]" "$CORE_EXTENSION_FILE"
fi
