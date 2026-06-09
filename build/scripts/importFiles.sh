#!/usr/bin/env sh
# Note! No private filesystem support.
set -e

# Raw filesystem import.
/scripts/importFilesRaw.sh "$1"

# Wrapper steps: re-apply public file permissions and secure the filesystem.
/scripts/pre-init.d/71_set_public_file_permissions.sh
/scripts/pre-init.d/72_secure_filesystems.sh
