#!/usr/bin/env sh
# Note! No private filesystem support.
set -e

if [ $# -ne 1 ];then
  echo "No public filesystem archive specified!"
  exit 1
elif [ ! -f "$1" ] ; then
  echo "$1 does not exist!"
  exit 1
fi

# Import the filesystem archive to the public filesystem.
tar -tzf "$1" >/dev/null # Check if the archive is valid.
# Preserve the reset-disarm marker across the wipe so post-import boots
# with DRUPAL_RESET_ON_INIT still set don't re-trigger a reset of the
# data we just imported.
RESET_MARKER="$DRUPAL_ROOT/sites/default/files/.drupal_reset_done"
PRESERVED_MARKER=
if [ -f "$RESET_MARKER" ]; then
  PRESERVED_MARKER=$(mktemp)
  cp "$RESET_MARKER" "$PRESERVED_MARKER"
fi
find "$DRUPAL_ROOT/sites/default/files" -mindepth 1 -delete
tar -xzf "$1" --directory "$DRUPAL_ROOT/sites/default/files/"
if [ -n "$PRESERVED_MARKER" ]; then
  mv "$PRESERVED_MARKER" "$RESET_MARKER"
fi
/scripts/pre-init.d/71_set_public_file_permissions.sh
/scripts/pre-init.d/72_secure_filesystems.sh
