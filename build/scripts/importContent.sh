#!/usr/bin/env sh
set -e

# Raw database import.
/scripts/importContentRaw.sh "$1"

# Wrapper step: rebuild the cache so the running site reflects the new data.
$DRUSH cr
