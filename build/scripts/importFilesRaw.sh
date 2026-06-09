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

# Raw filesystem import: extract the archive to the public filesystem. No
# permission/secure wrappers - callers that run the startup sequence afterward
# will apply 71/72 themselves.
tar -tzf "$1" >/dev/null # Check if the archive is valid.
find "$DRUPAL_ROOT/sites/default/files" -mindepth 1 -delete
tar -xzf "$1" --directory "$DRUPAL_ROOT/sites/default/files/"
