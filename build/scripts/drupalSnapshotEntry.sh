#!/usr/bin/env sh
set -e

# Entry point for creating a named, self-describing snapshot.
#
# Options:
#   --name=<name>          The snapshot name (default: nightly). Becomes the
#                          sub-directory under /snapshot. Overwrites in place.
#   --no-files             Skip the filestore (database-only snapshot).
#   --created-by=<str>     Provenance recorded in the manifest (default: cron).
#   --description=<str>    Free-text description recorded in the manifest.

SNAPSHOT_NAME="nightly"
SNAPSHOT_CREATED_BY="cron"
SNAPSHOT_DESCRIPTION=""
NO_FILES=""

for arg in "$@"; do
  case "$arg" in
    --name=*)        SNAPSHOT_NAME="${arg#*=}" ;;
    --created-by=*)  SNAPSHOT_CREATED_BY="${arg#*=}" ;;
    --description=*) SNAPSHOT_DESCRIPTION="${arg#*=}" ;;
    --no-files)      NO_FILES="--no-files" ;;
    *)
      echo "Error: Unknown option '$arg'" >&2
      exit 1
      ;;
  esac
done

# The name becomes a single path segment (and, upstream, a kubectl argument),
# so it must not permit path traversal or shell tricks.
if \
  ! echo "$SNAPSHOT_NAME" | grep -Eq '^[A-Za-z0-9._-]+$' || \
  [ "$SNAPSHOT_NAME" = "." ] || \
  [ "$SNAPSHOT_NAME" = ".." ]; then
  echo "Error: Invalid snapshot name '$SNAPSHOT_NAME'. Allowed: letters, numbers, dot, dash, underscore." >&2
  exit 1
fi

export SNAPSHOT_NAME SNAPSHOT_CREATED_BY SNAPSHOT_DESCRIPTION

SNAPSHOT_ROOT="/snapshot"
FINAL_PATH="$SNAPSHOT_ROOT/$SNAPSHOT_NAME"
STAGING_PATH="$SNAPSHOT_ROOT/.$SNAPSHOT_NAME.tmp"

# Cron is an efficient way to bootstrap Drupal without duplicating code.
# Skipping the cron itself at the end.
rm /scripts/pre-init.cron.d/94_drupal_cron.sh
/scripts/drupalCronEntry.sh

# Atomic write: export into a staging directory, write the manifest LAST, then
# swap it into place. A reader only ever sees a complete, manifest-stamped
# snapshot, and a failed run leaves the previous snapshot untouched. The staging
# directory is dot-prefixed so it is never listed as a snapshot.
rm -rf "$STAGING_PATH"
mkdir -p "$STAGING_PATH"
/scripts/exportData.sh "$STAGING_PATH" $NO_FILES
/scripts/writeSnapshotManifest.sh "$STAGING_PATH"
rm -rf "$FINAL_PATH"
mv "$STAGING_PATH" "$FINAL_PATH"

echo "Snapshot '$SNAPSHOT_NAME' written to $FINAL_PATH"
