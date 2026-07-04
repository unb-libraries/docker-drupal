#!/usr/bin/env sh
set -e

# Writes the snapshot manifest (snapshot.json) for a completed export.
# Delegates to PHP for safe JSON encoding; PHP is always present in this image.

if [ $# -ne 1 ]; then
  echo "No snapshot path specified." >&2
  exit 1
fi

exec php /scripts/writeSnapshotManifest.php "$1"
