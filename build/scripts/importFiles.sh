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
tar -tzf $1 >/dev/null # Check if the archive is valid.
rm -rf "$DRUPAL_ROOT/sites/default/files/*"
tar -xzf $1 --directory /
/scripts/pre-init.d/71_set_public_file_permissions.sh
/scripts/pre-init.d/72_secure_filesystems.sh
